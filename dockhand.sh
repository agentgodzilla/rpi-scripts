#!/usr/bin/env bash

# ensure root/sudo
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Not running as root"
    exit
fi

# setup paths if doesnt exist
mkdir /app/adgurad -p
chown $(who am i | awk '{print $1}') /app

# remove existing container if it exists
docker rm -f hawser || true

# create portainer agent container
docker run -d \
  --name hawser \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/hawser-stacks:/opt/hawser-stacks \
  -e STACKS_DIR=/opt/hawser-stacks \
  -e TOKEN=abc123 \
  -p 2376:2376 \
  ghcr.io/finsys/hawser:latest
