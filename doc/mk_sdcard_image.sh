#!/bin/bash -e

MOUNT_POINT="/tmp/mntpoint"
CUR_STEP=1
FORCE_INFLATION=0
# see define_partitions() for definition of partitions (sizes, number and label)

###############################################################################
# DomA configuration
###############################################################################
DOMA_SYSTEM_PARTITION_ID=1
DOMA_VENDOR_PARTITION_ID=2
DOMA_MISC_PARTITION_ID=3
DOMA_VBMETA_PARTITION_ID=4
DOMA_METADATA_PARTITION_ID=5
DOMA_USERDATA_PARTITION_ID=6

usage()
{
	echo "###############################################################################"
	echo "SD card image builder script v1.4"
	echo "###############################################################################"
	echo "Usage:"
	echo "`basename "$0"` <-p image-folder> <-d image-file> <-c config> [-s image-size] [-u domain]"
	echo "  -p image-folder Base daily build folder where artifacts live"
	echo "  -d image-file   Output image file or physical device"
	echo "  -c config       Configuration of partitions for product: aos, ces2019, devel or gen3"
	echo "  -s image-size   Optional, image size in GiB"
	echo "  -u domain       Optional, unpack only specified domain: dom0, domd, domf, doma, domu"
	echo "  -f              Optional, force rewrite of image file (useful for batch usage)"

	exit 1
}

define_partitions()
{
	# Define partitions for different products.
	# All numbers will be used as MiB (1024 KiB).
	# Products are listed in alphabetical order.
	case $1 in
		aos)
			# prod-aos [1..257][257..4257][4257..8257]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOM0_PARTITION=1
			DOM0_LABEL=boot
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+4000))  # 4257
			DOMD_PARTITION=2
			DOMD_LABEL=domd
			DOMF_START=$DOMD_END  # Also is used as flag that DomF is defined
			DOMF_END=$((DOMF_START+4000))  # 8257
			DOMF_PARTITION=3
			DOMF_LABEL=domf
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMF_END/1024)+1))
		;;
		ces2019)
			# prod-ces2019 [1..257][257..4257][4257..8680]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOM0_PARTITION=1
			DOM0_LABEL=boot
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+4000))  # 4257
			DOMD_PARTITION=2
			DOMD_LABEL=domd
			DOMA_START=$DOMD_END  # Also is used as flag that DomA is defined
			DOMA_END=$((DOMA_START+4440))  # 8697
			DOMA_PARTITION=3
			DOMA_LABEL=doma
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMA_END/1024)+1))
		;;
		devel)
			# prod-devel [1..257][257..2257][2257..6680]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOM0_PARTITION=1
			DOM0_LABEL=boot
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+2000))  # 2257
			DOMD_PARTITION=2
			DOMD_LABEL=domd
			DOMA_START=$DOMD_END  # Also is used as flag that DomA is defined
			DOMA_END=$((DOMA_START+4440))  # 6697
			DOMA_PARTITION=3
			DOMA_LABEL=doma
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMA_END/1024)+1))
		;;
		gen3)
			# prod-gen3-test [1..257][257..2257][2257..4257]
			DOM0_START=1
			DOM0_END=$((DOM0_START+256))  # 257
			DOM0_PARTITION=1
			DOM0_LABEL=boot
			DOMD_START=$DOM0_END
			DOMD_END=$((DOMD_START+2000))  # 2257
			DOMD_PARTITION=2
			DOMD_LABEL=domd
			DOMU_START=$DOMD_END  # Also is used as flag that DomU is defined
			DOMU_END=$((DOMU_START+2000))  # 4257
			DOMU_PARTITION=3
			DOMU_LABEL=domu
			DEFAULT_IMAGE_SIZE_GIB=$(((DOMU_END/1024)+1))
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

	# If SD card is specified as target, but not plugged into PC,
	# we will have incorrect situation: file will be created inside /dev folder
	# with name like /dev/sdc. This error sometimes is hard to clarify.
	# In order to avoid such confusion we will not create files inside /dev.
	if [[ "$dev" == /dev/* ]]; then
		echo "Error: device is not connected."
		exit 1
	fi

	echo "Inflating image file at $dev of size ${size_gb}GiB"

	local inflate=1
	if [ -e $1 ] && [ $FORCE_INFLATION -ne 1 ] ; then
		# if file exists and inflation is not forced then
		# ask user about rewriting of file
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
	if [ ! -z ${DOMF_START} ]; then
		sudo parted -s $1 mkpart primary ext4 ${DOMF_START}MiB ${DOMF_END}MiB || true
	fi
	if [ ! -z ${DOMU_START} ]; then
		sudo parted -s $1 mkpart primary ext4 ${DOMU_START}MiB ${DOMU_END}MiB || true
	fi
	if [ ! -z ${DOMA_START} ]; then
		sudo parted -s $1 mkpart primary ${DOMA_START}MiB ${DOMA_END}MiB || true
	fi
	sudo parted $1 print
	sudo partprobe $1

	if [ ! -z ${DOMA_START} ]; then
		# We have special handling for Android, because it has it's own partitions.
		# So, Android has dedicated partition number DOMA_PARTITION. And this partition
		# contains few 'internal' (Android's native) partitions.
		print_step "Make Android partitions on "${1}p$DOMA_PARTITION

		local loop_dev_a=`sudo losetup --find --partscan --show ${1}p$DOMA_PARTITION`

		# parted generates error on all operation with "nested" disk, guard it with || true
		sudo parted $loop_dev_a -s mklabel gpt || true
		sudo parted $loop_dev_a -s mkpart system    ext4 1MiB  3148MiB || true
		sudo parted $loop_dev_a -s mkpart vendor    ext4 3149MiB  3418MiB || true
		sudo parted $loop_dev_a -s mkpart misc      ext4 3419MiB  3420MiB || true
		sudo parted $loop_dev_a -s mkpart vbmeta    ext4 3421MiB  3422MiB || true
		sudo parted $loop_dev_a -s mkpart metadata  ext4 3423MiB  3434MiB || true
		sudo parted $loop_dev_a -s mkpart userdata  ext4 3435MiB  4435MiB || true
		sudo parted $loop_dev_a -s print
		sudo partprobe $loop_dev_a || true

		sudo losetup -d $loop_dev_a
	fi  # [ ! -z ${DOMA_START} ]
}

###############################################################################
# Make file system
###############################################################################

mkfs_one()
{
	local loop_base=$1
	local part=$2
	local label=$3

	print_step "Making ext4 filesystem for $label"

	sudo mkfs.ext4 -O ^64bit -F ${loop_base}p${part} -L $label
}

mkfs_boot()
{
	mkfs_one $1 $DOM0_PARTITION $DOM0_LABEL
}

mkfs_domd()
{
	mkfs_one $1 $DOMD_PARTITION $DOMD_LABEL
}

mkfs_domf()
{
	mkfs_one $1 $DOMF_PARTITION $DOMF_LABEL
}

mkfs_doma()
{
	# Below we use DOMA_METADATA_PARTITION_ID, DOMA_USERDATA_PARTITION_ID as number
	# of partition inside android's partition.So it's partitions
	# DOMA_METADATA_PARTITION_ID,DOMA_USERDATA_PARTITION_ID inside partition $DOMA_PARTITION.
	mkfs_one $1 ${DOMA_METADATA_PARTITION_ID} metadata
	mkfs_one $1 ${DOMA_USERDATA_PARTITION_ID} userdata
}

mkfs_domu()
{
	mkfs_one $1 $DOMU_PARTITION $DOMU_LABEL
}

mkfs_image()
{
	local img_output_file=$1

	mkfs_boot $img_output_file
	mkfs_domd $img_output_file
	if [ ! -z ${DOMF_START} ]; then
		mkfs_domf $img_output_file
	fi
	if [ ! -z ${DOMU_START} ]; then
		mkfs_domu $img_output_file
	fi
	if [ ! -z ${DOMA_START} ]; then
		local loop_dev_a=`sudo losetup --find --partscan --show ${img_output_file}p$DOMA_PARTITION`
		mkfs_doma $loop_dev_a
		sudo losetup -d $loop_dev_a
	fi

}

###############################################################################
# Mount partition
###############################################################################

mount_part()
{
	local loop_base=$1
	local part=$2
	local mntpoint=$3

	mkdir -p "${mntpoint}" || true
	sudo mount ${loop_base}p${part} "${mntpoint}"
}

umount_part()
{
	local loop_base=$1
	local part=$2

	sudo umount ${loop_base}p${part}
}

###############################################################################
# Unpack domain
###############################################################################

unpack_dom_from_tar()
{
	local db_base_folder=$1
	local loop_base=$2
	local part=$3
	local domain=$4

	local dom_name=`ls $db_base_folder | grep $domain`
	local dom_root=$db_base_folder/$dom_name
	# take the latest - useful if making image from local build
	local rootfs=`find $dom_root -name "*rootfs.tar.bz2" | xargs ls -t | head -1`

	echo "Root filesystem is at $rootfs"

	mount_part $loop_base $part $MOUNT_POINT

	sudo tar --extract --bzip2 --numeric-owner --preserve-permissions --preserve-order --totals \
		--xattrs-include='*' --directory="${MOUNT_POINT}" --file=$rootfs

	umount_part $loop_base $part
}

unpack_dom0()
{
	local db_base_folder=$1
	local loop_base=$2

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

	if [ $(echo "$Image" | wc -w) -gt 1 ]; then
		echo "Error: Too many kernel images were found."
		exit 1
	fi

	mount_part $loop_base $part $MOUNT_POINT

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

	print_step  "Unpacking DomD"

	unpack_dom_from_tar $db_base_folder $loop_dev $DOMD_PARTITION domd
}

unpack_domf()
{
	local db_base_folder=$1
	local loop_dev=$2

	print_step  "Unpacking DomF"

	unpack_dom_from_tar $db_base_folder $loop_dev $DOMF_PARTITION domu
}

unpack_domu()
{
	local db_base_folder=$1
	local loop_dev=$2

	print_step  "Unpacking DomU"

	unpack_dom_from_tar $db_base_folder $loop_dev $DOMU_PARTITION domu
}

unpack_doma()
{
	local db_base_folder=$1
	local loop_base=$2

	local raw_system="/tmp/system.raw"
	local raw_vendor="/tmp/vendor.raw"

	print_step "Unpacking DomA"

	local doma_name=`ls $db_base_folder | grep android`
	local doma_root=$db_base_folder/$doma_name
	local system=`find $doma_root -name "system.img"`
	local vendor=`find $doma_root -name "vendor.img"`
	local vbmeta=`find $doma_root -name "vbmeta.img"`

	echo "DomA system image is at $system"
	echo "DomA vendor image is at $vendor"

	simg2img $system $raw_system
	simg2img $vendor $raw_vendor

	sudo dd if=$raw_system of=${loop_base}p${DOMA_SYSTEM_PARTITION_ID} bs=1M status=progress
	sudo dd if=$raw_vendor of=${loop_base}p${DOMA_VENDOR_PARTITION_ID} bs=1M status=progress

	if [ ! -z ${vbmeta} ]; then
		sudo dd if=$vbmeta of=${loop_base}p${DOMA_VBMETA_PARTITION_ID} bs=1M status=progress
	fi

	echo "Wipe out DomA/misc"
	sudo dd if=/dev/zero of=${loop_base}p${DOMA_MISC_PARTITION_ID} bs=1M count=1 || true

	rm -f $raw_system $raw_vendor
}

unpack_image()
{
	local db_base_folder=$1
	local img_output_file=$2

	unpack_dom0 $db_base_folder $img_output_file
	unpack_domd $db_base_folder $img_output_file
	if [ ! -z ${DOMF_START} ]; then
		unpack_domf $db_base_folder $img_output_file
	fi
	if [ ! -z ${DOMU_START} ]; then
		unpack_domu $db_base_folder $img_output_file
	fi

	if [ ! -z ${DOMA_START} ]; then
		local out_adev=${img_output_file}p$DOMA_PARTITION
		sudo umount $out_adev || true
		while [[ ! (-b $out_adev) ]]; do
			# wait for $out_adev to appear
			sleep 1
		done
		local loop_dev_a=`sudo losetup --find --partscan --show $out_adev`
		unpack_doma $db_base_folder $loop_dev_a
		sudo losetup -d $loop_dev_a
	fi
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

	mkfs_image $img_output_file

	unpack_image $db_base_folder $img_output_file
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
			mkfs_boot $img_output_file
			unpack_dom0 $db_base_folder $img_output_file
		;;
		domd)
			mkfs_domd $img_output_file
			unpack_domd $db_base_folder $img_output_file
		;;
		domf)
			mkfs_domf $img_output_file
			unpack_domf $db_base_folder $img_output_file
		;;
		domu)
			mkfs_domu $img_output_file
			unpack_domu $db_base_folder $img_output_file
		;;
		doma)
			local loop_dev_a=`sudo losetup --find --partscan --show ${img_output_file}p$DOMA_PARTITION`
			mkfs_doma $loop_dev_a
			unpack_doma $db_base_folder $loop_dev_a
			sudo losetup -d $loop_dev_a
		;;
		*) echo "Invalid domain $domain" >&2
		exit 1
		;;
	esac
}

print_step "Parsing input parameters"

while getopts ":p:d:c:s:u:f" opt; do
	case $opt in
		p) ARG_DEPLOY_PATH="$OPTARG"
		;;
		d) ARG_DEPLOY_DEV="$OPTARG"
		;;
		c) ARG_CONFIGURATION="$OPTARG"
		;;
		s) ARG_IMG_SIZE_GIB="$OPTARG"
		;;
		u) ARG_UNPACK_DOM="$OPTARG"
		;;
		f) FORCE_INFLATION=1
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

define_partitions $ARG_CONFIGURATION

# Check that deploy path contains dom0, domd and doma
# also check for simg2img for android related images
dom0_name=`ls ${ARG_DEPLOY_PATH} | grep dom0-image-thin` || true
if [ -z "$dom0_name" ]; then
	echo "Error: deploy path has no dom0."
	exit 2
fi
domd_name=`ls ${ARG_DEPLOY_PATH} | grep domd` || true
if [ -z "$domd_name" ]; then
	echo "Error: deploy path has no domd."
	exit 2
fi
if [ ! -z ${DOMF_START} ]; then
	domf_name=`ls ${ARG_DEPLOY_PATH} | grep domu-image-fusion` || true
	if [ -z "$domf_name" ]; then
		echo "Error: deploy path has no domf."
		exit 2
	fi
fi
if [ ! -z ${DOMA_START} ]; then
	# simg2img is used only if we have android as guest
	if [ $(dpkg-query -W -f='${Status}' android-tools-fsutils 2>/dev/null | grep -c "ok installed") -eq 0 ];
	then
		echo "Please install simg2img (in debian-based: apt-get install android-tools-fsutils). Exiting.";
		exit;
	fi

	doma_name=`ls ${ARG_DEPLOY_PATH} | grep android` || true
	if [ -z "$doma_name" ]; then
		echo "Error: deploy path has no doma."
		exit 2
	fi
fi

echo "Using deploy path: \"$ARG_DEPLOY_PATH\""
echo "Using device     : \"$ARG_DEPLOY_DEV\""

if [ -z ${ARG_IMG_SIZE_GIB} ]; then
	ARG_IMG_SIZE_GIB=${DEFAULT_IMAGE_SIZE_GIB}
fi
inflate_image $ARG_DEPLOY_DEV $ARG_IMG_SIZE_GIB

loop_dev_in=`sudo losetup --find --partscan --show $ARG_DEPLOY_DEV`

if [ ! -z "${ARG_UNPACK_DOM}" ]; then
	unpack_domain $ARG_DEPLOY_PATH $loop_dev_in $ARG_UNPACK_DOM
else
	make_image $ARG_DEPLOY_PATH $loop_dev_in
fi

print_step "Syncing"
sync
sudo losetup -d $loop_dev_in

# if we write to file and we have bmaptool installed then
# let's create .bmap to speed up flashing of image
if [ ! -z `which bmaptool` ]; then
    if  [ ! -b $ARG_DEPLOY_DEV ] ; then
        print_step "Creating .bmap file"
        bmaptool create $ARG_DEPLOY_DEV -o $ARG_DEPLOY_DEV.bmap
        echo ".bmap was created, you can use"
        echo "sudo bmaptool copy $ARG_DEPLOY_DEV --bmap $ARG_DEPLOY_DEV.bmap /dev/sdX"
        echo "use 'sudo umount /dev/sdX?' if bmaptool has no exclusive access to /dev/sdX"
    fi
fi

print_step "Done all steps"
