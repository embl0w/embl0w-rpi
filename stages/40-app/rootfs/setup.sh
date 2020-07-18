#!/bin/bash
set -xe

apt update
apt install -y libgl1-mesa-dri
apt install -y kmscube

chmod 0600 /etc/ssh/ssh_host_*_key

mkdir /home/pi/.ssh
cp /ssh/pi.id_rsa.pub /home/pi/.ssh/authorized_keys
chown pi.pi -R /home/pi/.ssh
rm -rf /ssh

echo "PasswordAuthentication no" >>/etc/ssh/sshd_config

ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

systemctl enable wpa_supplicant@wlan0.service

apt-get clean
rm -f /setup.sh
