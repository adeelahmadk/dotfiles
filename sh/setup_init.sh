#!/usr/bin/env bash

if [[ $(id -u) -ne 0 ]]; then
   echo "root permissions required!" 
   sudo -v
   # exit 1
fi

# Update sources and Upgrade system
apt update && apt upgrade -y

# basics
apt install -y python3-pip python3-venv gparted ffmpeg conky-all
# improve cli
apt install -y source-highlight

# pip install -U --user pip youtube-dl 

# Allow net packet capture capability to conky for network monitoring
setcap cap_net_raw,cap_net_admin=eip /usr/bin/conky

# Dependencies for conky, html-xml-utils, etc.
apt install -y jq vnstat html-xml-utils update-notifier-common

# ArcMenu dependencies
#apt install -y gnome-shell-extensions gnome-menus gir1.2-gmenu-3.0

# install dev & publishing
apt install -y texlive texlive-extra-utils texlive-latex-extra texlive-font-utils fonts-font-awesome

# useful teminal utils
apt install ncdu nnn

# Some accessories
# flatpak install -y falkon 

