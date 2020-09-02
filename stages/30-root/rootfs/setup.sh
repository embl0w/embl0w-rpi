#!/bin/bash
set -xe

export LANG=C
export LC_ALL=C

: ${EL_USERNAME=pi}
: ${EL_PASSWORD=raspberry}
: ${EL_HOSTNAME=raspberrypi}

cat <<EOF >/etc/apt/apt.conf.d/no-install-recommends
APT::Install-Recommends false;
EOF

cat <<EOF >/etc/apt/sources.list
deb http://archive.raspbian.org/raspbian buster main contrib non-free rpi
deb http://archive.raspberrypi.org/debian buster main ui
EOF

apt update
apt dist-upgrade -y
apt install -y firmware-brcm80211
apt install -y \
        systemd \
        kmod \
        udev \
        dbus \
        busybox \
        wpasupplicant \
        ssh \
        vim-tiny \
        sudo \
        ca-certificates \
        iproute2 \
        iputils-ping
apt install -y \
        xserver-xorg \
        xserver-xorg-legacy \
        xserver-xorg-video-fbdev \
        xserver-xorg-input-evdev \
        libgles1 \
        libgles2 \
        openbox \
        xterm \
        xinit \
        fonts-droid-fallback \
        chromium-browser

for i in /lib/modules/*; do
	depmod -a ${i##*/}
done

groupadd -r spi
groupadd -r i2c
groupadd -r gpio
useradd -m -s /bin/bash -G adm,disk,input,audio,video,plugdev,netdev,root,tty,spi,i2c,gpio,render pi

echo "$EL_USERNAME:$EL_PASSWORD" | chpasswd

echo "$EL_USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sudoers

echo "$EL_HOSTNAME" >/etc/hostname

echo "127.0.1.1 $EL_HOSTNAME" >>/etc/hosts

cat <<'EOF' >>/home/pi/.profile
if test -x /app/ENTRYPOINT -a $(tty) = /dev/tty1; then
        cd /app && ./ENTRYPOINT
fi
EOF

systemctl enable systemd-networkd.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer

echo RuntimeWatchdogSec=14 >>/etc/systemd/system.conf

apt clean
rm -f /setup.sh
