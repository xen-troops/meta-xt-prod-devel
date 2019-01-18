#!/bin/sh

usage()
{
    echo "uirfs.sh [action] [file] [folder]"
    echo "	action	pack|unpack	"
    echo "	file	initramfs or uInitramfs file for unpack, uInitramfs for pack"
    echo "	folder	folder for initramfs pack/unpack (unpack will erase an existing folder)"

    if [ -n "$1" ]; then
        echo "\n\t $1 \n"
    fi

    exit 1
}

unpack()
{
    if [ ! -f $1 ] ; then
        usage "Missing file $1"
    fi

    if [ ! -d $2 ] && [ -e $2 ]; then
        usage "$2 is an existing file, expecting folder"
    fi

    if [ -e $2 ] && [ -n "$(ls -A $2)" ] ; then
        echo ""
        read -r -p "Folder $2 is not empty, erase it? [y/N]:" yesno
        case "$yesno" in
            [yY])
                rm -rf $2 || usage "Failed to cleanup $2"
                ;;
            *)
                usage "Abort due to unhappines of folder erasure"
                ;;
        esac
    fi

    mkdir -p $2
    cd $2

    if file -b $1 | cut -f 1 -d " " | grep -q "u-boot"; then
        dd if=$1 bs=1 skip=64 | gzip -cd | cpio -imd --quiet
    elif file -b $1 | cut -f 1 -d " " | grep -q "gzip"; then
        gzip -cd $1 | cpio -imd --quiet
    else
        usage "Wrong file <$1>"
    fi

    echo "\n\tuInitramfs unpacked to:"
    echo "\t $2"
}

pack()
{
    if [ ! -d $2 ]; then
        usage "$2 is not an existing folder"
    fi

    if [ -e $1 ] ; then
        echo ""
        read -r -p "Path $1 is existing, remove it? [y/N]:" yesno
        case "$yesno" in
            [yY])
                rm -f $1 || usage "Failed to remove $1, a folder?"
                ;;
            *)
                usage "Abort due to unhappines of a path removing"
                ;;
        esac
    fi

    cd $2
    FILE=`mktemp`
    find . | cpio --quiet -R 0:0 -H newc -o | gzip -9 -n > $FILE
    mkimage -A arm64 -O linux -T ramdisk -C gzip -n "uInitramfs" -d $FILE $1
    rm -f $FILE

    echo "\n\tPacked uInitramfs file:"
    echo "\t $1"
}


if [ "$#" != "3" ]
then
    usage "Not enough parameters"
fi

if [ "$1" = "pack" ] ; then
    pack `realpath $2` `realpath $3`
elif [ "$1" = "unpack" ] ; then
    unpack `realpath $2` `realpath $3`
else
    usage "Wrong action <$1>"
fi
