#!/bin/bash
set -xe

cat <<EOF >/etc/apt/sources.list
deb http://archive.raspbian.org/raspbian buster main contrib non-free rpi
deb http://archive.raspberrypi.org/debian buster main ui
EOF

cat <<EOF >/etc/apt/apt.conf.d/no-install-recommends
APT::Install-Recommends false;
EOF

apt-get update -y
apt-get dist-upgrade -y
apt-get install -y firmware-brcm80211
apt-get install -y systemd kmod udev dbus busybox wpasupplicant ssh vim-tiny sudo ca-certificates iproute2 iputils-ping

for i in /lib/modules/*; do
	depmod -a ${i##*/}
done

groupadd -r spi
groupadd -r i2c
groupadd -r gpio
useradd -m -s /bin/bash -G adm,disk,input,audio,video,plugdev,netdev,root,tty,spi,i2c,gpio,render pi

product="${1-raspberry}"
echo "pi:$product" | chpasswd

echo "127.0.1.1 $(cat /etc/hostname)" >>/etc/hosts

cat <<'EOF' >>/home/pi/.profile
if test -x /app/ENTRYPOINT -a $(tty) = /dev/tty1; then
        cd /app && ./ENTRYPOINT
fi
EOF

systemctl enable loadkmap.service
systemctl enable systemd-networkd.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer

echo RuntimeWatchdogSec=14 >>/etc/systemd/system.conf

apt-get clean
rm -f /setup.sh
