#!/usr/bin/env bash

# ensure root/sudo
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

apt update
apt upgrade
apt full-upgrade
apt autoremove
