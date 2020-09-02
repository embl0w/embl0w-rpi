#!/bin/bash
set -xe

: ${EL_USERNAME=pi}
: ${EL_HOMEDIR=/home/$EL_USERNAME}

chmod 0600 /etc/ssh/ssh_host_*_key

mkdir $EL_HOMEDIR/.ssh
cp /ssh/id_rsa.pub $EL_HOMEDIR/.ssh/authorized_keys
chown $EL_USERNAME.$EL_USERNAME -R $EL_HOMEDIR/.ssh
rm -rf /ssh

echo "PasswordAuthentication no" >>/etc/ssh/sshd_config

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

systemctl enable wpa_supplicant@wlan0.service

for i in /lib/modules/*; do
	case ${i##*/} in
    *-v7+) ;;
    *-v7l+) ;;
    *-v8+) rm -rf $i ;;
    *) rm -rf $i ;;
    esac
done

rm -f /boot/*.bin /boot/*.dat /boot/*.elf /boot/LICENCE.broadcom

apt-get clean
rm -f /setup.sh
