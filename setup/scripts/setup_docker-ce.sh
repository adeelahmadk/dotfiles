#!/usr/bin/env bash

sudo -v
echo "upgrading packages..."

sudo apt update && sudo apt upgrade

sudo -v
echo "adding docker official gpg key..."

sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

[ "$?" -ne 0 ] && {
  echo "encountered error!"
  exit 1
}

echo "adding the repository to apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "installing packages..."
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

[ "$?" -ne 0 ] && {
  echo "encountered error!"
  exit 1
}
echo "\ndone!"
