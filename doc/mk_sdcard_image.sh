#!/bin/bash -e

MOUNT_POINT="/tmp/mntpoint"
CUR_STEP=1

usage()
{
	echo "###############################################################################"
	echo "SD card image builder script for current development product."
	echo "###############################################################################"
	echo "Usage:"
	echo "`basename "$0"` <-p image-folder> <-d image-file> [-s image-size-gb] [-u dom0|domd|domf|doma]"
	echo "	-p image-folder	Base daily build folder where artifacts live"
	echo "	-d image-file	Output image file or physical device"
	echo "	-s image-size	Optional, image size in GB"
	echo "  -u domain	Optional, unpack the domain specified"

	exit 1
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

	echo "Inflating image file at $dev of size ${size_gb}GB"
	return 0

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
		sudo dd if=/dev/zero of=$dev bs=1M count=$(($size_gb*1024)) || exit 1
	fi
}

###############################################################################
# Partition image
###############################################################################
partition_image()
{
	print_step "Make partitions"

	sudo parted -s $1 mklabel msdos

	sudo parted -s $1 mkpart primary ext4 1MiB 257MiB
	sudo parted -s $1 mkpart primary ext4 257MiB 2257MiB
	sudo parted -s $1 mkpart primary ext4 2257MiB 3415MiB
	sudo parted -s $1 mkpart extended 3415MiB 100% 
	sudo parted -s $1 mkpart logical ext4 3416MiB 5515MiB
	sudo parted -s $1 mkpart logical ext4 5516MiB 5773MiB
	sudo parted -s $1 mkpart logical ext4 5774MiB 5775MiB
	sudo parted -s $1 mkpart logical ext4 5776MiB 100%
	sudo parted $1 print

	sudo partprobe $1
}

###############################################################################
# Label partition
###############################################################################

label_one()
{
	local loop_base=$1
	local part=$2
	local label=$3
	local loop_dev="${loop_base}p${part}"

	sudo e2label $loop_dev $label
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

mkfs_domf()
{
	local img_output_file=$1
	local loop_dev=$2

	mkfs_one $img_output_file $loop_dev 3 domf
}

mkfs_doma()
{
	local img_output_file=$1
	local loop_dev=$2

	mkfs_one $img_output_file $loop_dev 8 doma_user
}

mkfs_image()
{
	local img_output_file=$1
	local loop_dev=$2
	sudo losetup -P $loop_dev $img_output_file

	mkfs_boot $img_output_file $loop_dev
	mkfs_domd $img_output_file $loop_dev
	mkfs_domf $img_output_file $loop_dev
	mkfs_doma $img_output_file $loop_dev
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

unpack_domf()
{
	local db_base_folder=$1
	local loop_dev=$2
	local img_output_file=$3

	print_step  "Unpacking DomF"

	unpack_dom_from_tar $db_base_folder $loop_dev $img_output_file 3 fusion
}

unpack_doma()
{
	local db_base_folder=$1
	local loop_base=$2
	local img_output_file=$3

	local part_system=5
	local part_vendor=6
	local part_misc=7

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

	sudo dd if=$raw_system of=${loop_base}p${part_system} bs=1M
	sudo dd if=$raw_vendor of=${loop_base}p${part_vendor} bs=1M

	echo "Wipe out DomA/misc"
	sudo dd if=/dev/zero of=${loop_base}p${part_misc} || true

	rm -f $raw_system $raw_vendor

	echo "Put label for system partition"
	label_one ${loop_base} ${part_system} doma_sys
}

unpack_image()
{
	local db_base_folder=$1
	local loop_dev=$2
	local img_output_file=$3

	unpack_dom0 $db_base_folder $loop_dev $img_output_file
	unpack_domd $db_base_folder $loop_dev $img_output_file
	unpack_domf $db_base_folder $loop_dev $img_output_file
	unpack_doma $db_base_folder $loop_dev $img_output_file
}

###############################################################################
# Common
###############################################################################

make_image()
{
	local db_base_folder=$1
	local img_output_file=$2
	local image_sg_gb=${3:-16}
	local loop_dev="/dev/loop0"

	print_step "Preparing image at ${img_output_file}"
	ls ${img_output_file}?* | xargs -n1 sudo umount -l -f || true

	sudo umount -f ${img_output_file}* || true

	inflate_image $img_output_file $image_sg_gb
	partition_image $img_output_file
	mkfs_image $img_output_file $loop_dev
	unpack_image $db_base_folder $loop_dev $img_output_file

	sync
	sudo losetup -d $loop_dev || true
	print_step "Done"
}

unpack_domain()
{
	local db_base_folder=$1
	local img_output_file=$2
	local domain=$3
	local loop_dev="/dev/loop0"

	print_step "Unpacking single domain: $domain"

	sudo umount -f ${img_output_file}* || true
	sudo losetup -d $loop_dev || true

	case $domain in
		dom0)
			mkfs_boot $img_output_file $loop_dev
			unpack_dom0 $db_base_folder $loop_dev $img_output_file
		;;
		domd)
			mkfs_domd $img_output_file $loop_dev
			unpack_domd $db_base_folder $loop_dev $img_output_file
		;;
		domf)
			mkfs_domf $img_output_file $loop_dev
			unpack_domf $db_base_folder $loop_dev $img_output_file
		;;
		doma)
			mkfs_doma $img_output_file $loop_dev
			unpack_doma $db_base_folder $loop_dev $img_output_file
		;;
		\?) echo "Invalid domain -$OPTARG" >&2
		exit 1
		;;
	esac

	sync
	print_step "Done"
}

print_step "Checking for simg2img"

if [ $(dpkg-query -W -f='${Status}' android-tools-fsutils 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
   echo "Please install simg2img (in debian-based: apt-get install android-tools-fsutils). Exiting.";
   exit;
fi

print_step "Parsing input parameters"

while getopts ":p:d:s:u:" opt; do
	case $opt in
		p) ARG_DEPLOY_PATH="$OPTARG"
		;;
		d) ARG_DEPLOY_DEV="$OPTARG"
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

echo "Using deploy path: \"$ARG_DEPLOY_PATH\""
echo "Using device     : \"$ARG_DEPLOY_DEV\""

if [ ! -z "${ARG_UNPACK_DOM}" ]; then
	unpack_domain $ARG_DEPLOY_PATH $ARG_DEPLOY_DEV $ARG_UNPACK_DOM
else
	make_image $ARG_DEPLOY_PATH $ARG_DEPLOY_DEV $ARG_IMG_SIZE_GB
fi

