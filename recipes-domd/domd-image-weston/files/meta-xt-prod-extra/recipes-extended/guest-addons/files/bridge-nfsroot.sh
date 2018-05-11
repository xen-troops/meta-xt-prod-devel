set -x
modprobe bridge

mount -o remount,exec /run
R=/run/root
IPADDR=`ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`

mkdir -p "$R/proc" "$R/usr" "$R/dev" "$R/lib"
cp -r /bin /sbin bridge.sh "$R"
cp /usr/sbin/brctl* "$R/bin"
pushd .
cd /lib
cp -r `ls -A | grep -v "modules\|depmod\|firmware\|modprobe"` "$R/lib"
popd
cp -r /usr/sbin "$R/usr/sbin"
cat > "$R/script" <<EOF
mount -t proc none /proc
PATH=$PATH:"/sbin"

busybox rm /bin/hostname /bin/ifconfig
busybox ln -s /bin/busybox /bin/ifconfig

brctl addbr xenbr0
brctl stp xenbr0 off
brctl setfd xenbr0 0
brctl addif xenbr0 eth0
busybox ifconfig eth0 0.0.0.0
busybox ifconfig xenbr0 "$IPADDR"

busybox umount /proc
EOF
busybox chroot "$R" busybox sh script
rm -r "$R"
