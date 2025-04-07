#!/usr/bin/env bash

# ensure root/sudo
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

# disable crap
systemctl disable vncserver-x11-serviced.service vncserver-virtuald.service

# set timezone
echo "US/Central" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# install docker
apt -y update
apt -y install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt -y update
apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# configure auto updates
apt -y install unattended-upgrades apt-listchanges needrestart
echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades
echo -e "Unattended-Upgrade::Automatic-Reboot \"true\";\nUnattended-Upgrade::Remove-Unused-Dependencies \"true\";\nUnattended-Upgrade::Origins-Pattern {\n    \"o=*\";\n}" > /etc/apt/apt.conf.d/52unattended-upgrades-local
