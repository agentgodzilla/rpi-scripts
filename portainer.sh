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
docker rm -f portainer_agent || true

# create portainer agent container
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  --pull=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  -v /:/host \
  portainer/agent:sts
