#!/bin/sh

usage()
{
    echo "uirfs.sh [action] [file] [folder]"
    echo "	action	pack|unpack|force-pack|force-unpack (use force- to remove destination without question)"
    echo "	file	initramfs or uInitramfs file for unpack, uInitramfs for pack"
    echo "	folder	folder for initramfs pack/unpack"

    if [ -n "$1" ]; then
        echo "\n\t $1 \n"
    fi

    exit 1
}

unpack()
{
    local file_name=$1
    local dir_name=$2
    local force=$3

    if [ ! -f $file_name ] ; then
        usage "Missing file $file_name"
    fi

    if [ ! -d $dir_name ] && [ -e $dir_name ]; then
        usage "$dir_name is an existing file, expecting folder"
    fi

    if [ -e $dir_name ] && [ -n "$(ls -A $dir_name)" ] ; then
        if [ $force -eq 1 ] ; then
            rm -rf $dir_name
        else
            echo ""
            read -r -p "Folder $dir_name is not empty, erase it? [y/N]:" yesno
            case "$yesno" in
                [yY])
                    rm -rf $dir_name || usage "Failed to cleanup $dir_name"
                    ;;
                *)
                    usage "Abort due to unhappines of folder erasure"
                    ;;
            esac
        fi
    fi

    mkdir -p $dir_name
    cd $dir_name

    if file -b $file_name | cut -f 1 -d " " | grep -q "u-boot"; then
        dd if=$file_name bs=1 skip=64 | gzip -cd | cpio -imd --quiet
    elif file -b $file_name | cut -f 1 -d " " | grep -q "gzip"; then
        gzip -cd $file_name | cpio -imd --quiet
    else
        usage "Wrong file <$file_name>"
    fi

    echo "\n\tuInitramfs unpacked to:"
    echo "\t $dir_name"
}

pack()
{
    local file_name=$1
    local dir_name=$2
    local force=$3

    if [ ! -d $dir_name ]; then
        usage "$dir_name is not an existing folder"
    fi

    if [ -e $file_name ] ; then
        if [ $force -eq 1 ] ; then
            rm -f $file_name
        else
            echo ""
            read -r -p "Path $file_name exists, remove it? [y/N]:" yesno
            case "$yesno" in
                [yY])
                    rm -f $file_name || usage "Failed to remove $file_name, a folder?"
                    ;;
                *)
                    usage "Abort due to unhappines of a path removing"
                    ;;
            esac
        fi
    fi

    cd $dir_name
    FILE=`mktemp`
    find . | cpio --quiet -R 0:0 -H newc -o | gzip -9 -n > $FILE
    mkimage -A arm64 -O linux -T ramdisk -C gzip -n "uInitramfs" -d $FILE $file_name
    rm -f $FILE

    echo "\n\tPacked uInitramfs file:"
    echo "\t $file_name"
}


if [ "$#" != "3" ]
then
    usage "Not enough parameters"
fi

if [ "$1" = "pack" ] ; then
    pack `realpath $2` `realpath $3`
elif [ "$1" = "unpack" ] ; then
    unpack `realpath $2` `realpath $3`
elif [ "$1" = "force-pack" ] ; then
    pack `realpath $2` `realpath $3` 1
elif [ "$1" = "force-unpack" ] ; then
    unpack `realpath $2` `realpath $3` 1
else
    usage "Wrong action <$1>"
fi
