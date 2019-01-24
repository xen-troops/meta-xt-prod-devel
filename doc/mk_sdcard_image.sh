#!/bin/bash -e

MOUNT_POINT="/tmp/mntpoint"
CUR_STEP=1
DOMA_PART_N=p3
# see define_sizes_of_partitions() for definition of sizes of partitions

usage()
{
	echo "###############################################################################"
	echo "SD card image builder script v1.0"
	echo "###############################################################################"
	echo "Usage:"
	echo "`basename "$0"` <-p image-folder> <-d image-file> <-c devel|ces2019> [-s image-size] [-u dom0|domd|doma]"
	echo "	-p image-folder	Base daily build folder where artifacts live"
	echo "	-d image-file	Output image file or physical device"
	echo "	-c config       Configuration of partitions for product: devel or ces2019"
	echo "	-s image-size	Optional, image size in GiB"
	echo "	-u domain	Optional, unpack the domain specified"

	exit 1
}

define_sizes_of_partitions()
{
	# Define partitions for different products.
	# All numbers will be used as MiB (1024 KiB).
	case $1 in
		ces2019)
			# prod-ces2019 [1..257][257..4257][4257..8680]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+4000))  # 4257
			DOMA_START=$DOMD_END  # 4257
			DOMA_END=$((DOMA_START+4423))  # 8680
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMA_END/1024)+1))
			DOMA_PRESENT=1
		;;
		devel)
			# prod-devel [1..257][257..2257][2257..6680]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+2000))  # 2257
			DOMA_START=$DOMD_END  # 2257
			DOMA_END=$((DOMA_START+4423))  # 6680
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMA_END/1024)+1))
			DOMA_PRESENT=1
		;;
		*)
			echo "Unknown configuration provided for -c."
			exit 1
		;;
	esac
}

print_step()
{
	local caption=$1
	echo "###############################################################################"
	echo "Step $CUR_STEP: $caption"
	echo "###############################################################################"
	((CUR_STEP++))
}

###############################################################################
# Inflate image
###############################################################################
inflate_image()
{
	local dev=$1
	local size_gb=$2

	print_step "Inflate image"
	echo "DEV -" $dev
	if  [ -b "$dev" ] ; then
		echo "Using physical block device $dev"
		return 0
	fi

	echo "Inflating image file at $dev of size ${size_gb}GiB"

	local inflate=1
	if [ -e $1 ] ; then
		echo ""
		read -r -p "File $dev exists, remove it? [y/N]:" yesno
		case "$yesno" in
		[yY])
			sudo rm -f $dev || exit 1
		;;
		*)
			echo "Reusing existing image file"
			inflate=0
		;;
		esac
	fi
	if [[ $inflate == 1 ]] ; then
		sudo dd if=/dev/zero of=$dev bs=1M count=0 seek=$(($size_gb*1024)) || exit 1
	fi
}

###############################################################################
# Partition image
###############################################################################
partition_image()
{
	print_step "Make partitions"

	# create partitions
	sudo parted -s $1 mklabel msdos || true

	sudo parted -s $1 mkpart primary ext4 ${DOM0_START}MiB ${DOM0_END}MiB || true
	sudo parted -s $1 mkpart primary ext4 ${DOMD_START}MiB ${DOMD_END}MiB || true
	sudo parted -s $1 mkpart primary ${DOMA_START}MiB ${DOMA_END}MiB || true
	sudo parted $1 print
	sudo partprobe $1

	print_step "Make Android partitions on "$1$DOMA_PART_N

	local temp_dev=`sudo losetup --find --partscan --show $1$DOMA_PART_N`

	# parted gerates error on all operation with "nested" disk, guard it with || true
	sudo parted $temp_dev -s mklabel gpt || true
	sudo parted $temp_dev -s mkpart xvda1 ext4 1MB  3148MB || true
	sudo parted $temp_dev -s mkpart xvda2 ext4 3149MB  3418MB || true
	sudo parted $temp_dev -s mkpart xvda3 ext4 3419MB  3420MB || true
	sudo parted $temp_dev -s mkpart xvda4 ext4 3421MB  4421MB || true
	sudo parted $temp_dev -s print
	sudo partprobe $temp_dev || true

	sudo losetup -d $temp_dev
}

###############################################################################
# Make file system
###############################################################################

mkfs_one()
{
	local img_output_file=$1
	local loop_base=$2
	local part=$3
	local label=$4
	local loop_dev="${loop_base}p${part}"

	print_step "Making ext4 filesystem for $label"

	sudo mkfs.ext4 -O ^64bit -F $loop_dev -L $label
}

mkfs_boot()
{
	local img_output_file=$1
	local loop_dev=$2

	mkfs_one $img_output_file $loop_dev 1 boot
}

mkfs_domd()
{
	local img_output_file=$1
	local loop_dev=$2

	mkfs_one $img_output_file $loop_dev 2 domd
}

mkfs_doma()
{
	local img_output_file=$1
	local loop_dev=$2

	# Below we use 4 as number of partition inside android's partition.
	# So it's partition 4 inside partition $DOMA_PART_N.
	mkfs_one $img_output_file $loop_dev 4 doma_user
}

mkfs_image()
{
	local img_output_file=$1
	local loop_dev=$2

	mkfs_boot $img_output_file $loop_dev
	mkfs_domd $img_output_file $loop_dev

	local out_adev=$img_output_file$DOMA_PART_N
	sudo losetup -d $loop_dev
	loop_dev=`sudo losetup --find --partscan --show $out_adev`
	mkfs_doma $img_output_file $loop_dev
	sudo losetup -d $loop_dev
}

###############################################################################
# Mount partition
###############################################################################

mount_part()
{
	local loop_base=$1
	local img_output_file=$2
	local part=$3
	local mntpoint=$4
	local loop_dev=${loop_base}p${part}

	mkdir -p "${mntpoint}" || true
	sudo mount $loop_dev "${mntpoint}"
}

umount_part()
{
	local loop_base=$1
	local part=$2
	local loop_dev=${loop_base}p${part}

	sudo umount $loop_dev
}

###############################################################################
# Unpack domain
###############################################################################

unpack_dom_from_tar()
{
	local db_base_folder=$1
	local loop_base=$2
	local img_output_file=$3
	local part=$4
	local domain=$5
	local loop_dev=${loop_base}p${part}

	local dom_name=`ls $db_base_folder | grep $domain`
	local dom_root=$db_base_folder/$dom_name
	# take the latest - useful if making image from local build
	local rootfs=`find $dom_root -name "*rootfs.tar.bz2" | xargs ls -t | head -1`

	echo "Root filesystem is at $rootfs"

	mount_part $loop_base $img_output_file $part $MOUNT_POINT

	sudo tar --extract --bzip2 --numeric-owner --preserve-permissions --preserve-order --totals \
		--xattrs-include='*' --directory="${MOUNT_POINT}" --file=$rootfs

	umount_part $loop_base $part
}

unpack_dom0()
{
	local db_base_folder=$1
	local loop_base=$2
	local img_output_file=$3

	local part=1

	print_step "Unpacking Dom0"

	local dom0_name=`ls $db_base_folder | grep dom0-image-thin`
	local dom0_root=$db_base_folder/$dom0_name

	local domd_name=`ls $db_base_folder | grep domd`
	local domd_root=$db_base_folder/$domd_name

	local Image=`find $dom0_root -name Image`
	local uInitramfs=`find $dom0_root -name uInitramfs`
	local dom0dtb=`find $domd_root -name dom0.dtb`
	local xenpolicy=`find $domd_root -name xenpolicy`
	local xenuImage=`find $domd_root -name xen-uImage`

	echo "Dom0 kernel image is at $Image"
	echo "Dom0 initramfs is at $uInitramfs"
	echo "Dom0 device tree is at $dom0dtb"
	echo "Xen policy is at $xenpolicy"
	echo "Xen image is at $xenuImage"

	mount_part $loop_base $img_output_file $part $MOUNT_POINT

	sudo mkdir "${MOUNT_POINT}/boot" || true

	for f in $Image $uInitramfs $dom0dtb $xenpolicy $xenuImage ; do
		sudo cp -L $f "${MOUNT_POINT}/boot/"
	done

	umount_part $loop_base $part
}

unpack_domd()
{
	local db_base_folder=$1
	local loop_dev=$2
	local img_output_file=$3

	print_step  "Unpacking DomD"

	unpack_dom_from_tar $db_base_folder $loop_dev $img_output_file 2 domd
}

unpack_doma()
{
	local db_base_folder=$1
	local loop_base=$2
	local img_output_file=$3

	local part_system=1
	local part_vendor=2
	local part_misc=3

	local raw_system="/tmp/system.raw"
	local raw_vendor="/tmp/vendor.raw"

	print_step "Unpacking DomA"

	local doma_name=`ls $db_base_folder | grep android`
	local doma_root=$db_base_folder/$doma_name
	local system=`find $doma_root -name "system.img"`
	local vendor=`find $doma_root -name "vendor.img"`

	echo "DomA system image is at $system"
	echo "DomA vendor image is at $vendor"

	simg2img $system $raw_system
	simg2img $vendor $raw_vendor

	sudo dd if=$raw_system of=${loop_base}p${part_system} bs=1M status=progress
	sudo dd if=$raw_vendor of=${loop_base}p${part_vendor} bs=1M status=progress

	echo "Wipe out DomA/misc"
	sudo dd if=/dev/zero of=${loop_base}p${part_misc} bs=1M count=1 || true

	rm -f $raw_system $raw_vendor
}

unpack_image()
{
	local db_base_folder=$1
	local loop_dev=$2
	local img_output_file=$3

	unpack_dom0 $db_base_folder $loop_dev $img_output_file
	unpack_domd $db_base_folder $loop_dev $img_output_file

	local out_adev=$img_output_file$DOMA_PART_N
	sudo umount $out_adev || true
	sudo losetup -d $loop_dev
	while [[ ! (-b $out_adev) ]]; do
		: # wait for $out_adev to appear
	done
	loop_dev=`sudo losetup --find --partscan --show $out_adev`
	unpack_doma $db_base_folder $loop_dev $img_output_file
	sudo losetup -d $loop_dev
}

###############################################################################
# Common
###############################################################################

make_image()
{
	local db_base_folder=$1
	local img_output_file=$2

	print_step "Preparing image at ${img_output_file}"
	ls ${img_output_file}?* | xargs -n1 sudo umount -l -f || true

	sudo umount -f ${img_output_file}* || true

	partition_image $img_output_file

	loop_dev=`sudo losetup --find --partscan --show $img_output_file`
	mkfs_image $img_output_file $loop_dev
	# $loop_dev closed by mkfs_image

	loop_dev=`sudo losetup --find --partscan --show $img_output_file`
	unpack_image $db_base_folder $loop_dev $img_output_file
	# $loop_dev closed by unpack_image
}

unpack_domain()
{
	local db_base_folder=$1
	local img_output_file=$2
	local domain=$3


	print_step "Unpacking single domain: $domain"

	sudo umount -f ${img_output_file}* || true
	case $domain in
		dom0)
			loop_dev=`sudo losetup --find --partscan --show $img_output_file`
			mkfs_boot $img_output_file $loop_dev
			unpack_dom0 $db_base_folder $loop_dev $img_output_file
		;;
		domd)
			loop_dev=`sudo losetup --find --partscan --show $img_output_file`
			mkfs_domd $img_output_file $loop_dev
			unpack_domd $db_base_folder $loop_dev $img_output_file
		;;
		doma)
			img_output_file=$img_output_file$DOMA_PART_N
			loop_dev=`sudo losetup --find --partscan --show $img_output_file`
			mkfs_doma $img_output_file $loop_dev
			unpack_doma $db_base_folder $loop_dev $img_output_file
		;;
		*) echo "Invalid domain $domain" >&2
		exit 1
		;;
	esac
	sudo losetup -d $loop_dev
}

print_step "Checking for simg2img"

if [ $(dpkg-query -W -f='${Status}' android-tools-fsutils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
   echo "Please install simg2img (in debian-based: apt-get install android-tools-fsutils). Exiting.";
   exit;
fi

print_step "Parsing input parameters"

while getopts ":p:d:c:s:u:" opt; do
	case $opt in
		p) ARG_DEPLOY_PATH="$OPTARG"
		;;
		d) ARG_DEPLOY_DEV="$OPTARG"
		;;
		c) ARG_CONFIGURATION="$OPTARG"
		;;
		s) ARG_IMG_SIZE_GB="$OPTARG"
		;;
		u) ARG_UNPACK_DOM="$OPTARG"
		;;
		\?) echo "Invalid option -$OPTARG" >&2
		exit 1
		;;
	esac
done

if [ -z "${ARG_DEPLOY_PATH}" ]; then
	echo "No path to deploy directory passed with -p option"
	usage
fi

if [ -z "${ARG_DEPLOY_DEV}" ]; then
	echo "No device/file name passed with -d option"
	usage
fi

if [ -z "${ARG_CONFIGURATION}" ]; then
	echo "Configuration of partitions is not defined. Use -c option."
	usage
fi

# Check that deploy path contains dom0, domd and doma
dom0_name=`ls ${ARG_DEPLOY_PATH} | grep dom0-image-thin` || true
domd_name=`ls ${ARG_DEPLOY_PATH} | grep domd` || true
doma_name=`ls ${ARG_DEPLOY_PATH} | grep android` || true
if [ -z "$dom0_name" ]; then
	echo "Error: deploy path has no dom0."
	exit 2
fi
if [ -z "$domd_name" ]; then
	echo "Error: deploy path has no domd."
	exit 2
fi
if [ -z "$doma_name" ]; then
	echo "Error: deploy path has no doma."
	exit 2
fi

define_sizes_of_partitions $ARG_CONFIGURATION

echo "Using deploy path: \"$ARG_DEPLOY_PATH\""
echo "Using device     : \"$ARG_DEPLOY_DEV\""

if [ -z ${ARG_IMG_SIZE_GB} ]; then
	ARG_IMG_SIZE_GB=${DEFAULT_IMAGE_SIZE_GIB}
fi
inflate_image $ARG_DEPLOY_DEV $ARG_IMG_SIZE_GB

loop_dev_in=`sudo losetup --find --partscan --show $ARG_DEPLOY_DEV`

if [ ! -z "${ARG_UNPACK_DOM}" ]; then
	unpack_domain $ARG_DEPLOY_PATH $loop_dev_in $ARG_UNPACK_DOM
else
	make_image $ARG_DEPLOY_PATH $loop_dev_in
fi

print_step "Syncing"
sync
sudo losetup -d $loop_dev_in
print_step "Done all steps"
