#!/bin/bash

# First install all languages:
# git, make, python, pip, npm, node, cargo, nvim and golang

_DIST=
_SHELL=`basename $SHELL`
_PKG=

if [ -f /etc/os-release ]; then
    . /etc/os-release

    [ -n "$ID" ] && _DIST="$ID" || \
    [ -n "$ID_LIKE" ] && _DIST="$ID_LIKE"

    if [[ "$_DIST" == "debian" || "$_DIST" == "ubuntu" ]]; then
    		_PKG="command -v apt"
	elif [[ "$_DIST" == "arch" ]]; then
		_PKG="command -v pacman"
	fi
fi

if [[ $(id -u) -ne 0 ]]; then
   echo "root permissions required!"
   sudo -v
   # exit 1
fi

if [[ "$_DIST" == "debian" || "$_DIST" == "ubuntu" ]]; then
    sudo apt install -y \
        software-properties-common \
        gparted ffmpeg \
        git make curl ripgrep \
        pkg-config build-essential libfontconfig1-dev \
        htop tree ncdu ranger \ # lm-sensors
        python3-pip python3-venv python3-argcomplete pipx \
        html-xml-utils source-highlight \
        tldr-py httpie
    echo "recommended: flameshot bleachbit qdirstat"
elif [[ "$_DIST" == "arch" ]]; then
    sudo pacman -Syu git ncdu \
        html-xml-utils source-highlight \
        mkcert tldr httpie \
        qdirstat bleachbit
fi

if [[ "$_SHELL" == "bash" ]]; then

  # append color highlight setup to bashrc
  cat <<EOF >> ~/.bashrc

# Enable source highlighting in `less` pager (dep: source-highlight)
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R'
EOF

fi

sudo -v

if [[ "$_DIST" == "debian" || "$_DIST" == "ubuntu" ]]

    ## install pacstall
    sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install || wget -q https://pacstall.dev/q/install -O -)"
    ## install neovim latest from pacstall repo
    pacstall -I neovim

fi

sudo -v
decision="y"
if command -v gnome-shell > /dev/null; then
  printf "%s is installed\n" "$(gnome-sell --version)"
  read -p "Install customization tools (y/n)?" -n1 -r choice
  case "$choice" in
    y|Y ) decision="y";;
    n|N ) decision="n";;
    * )   decision="n";;
  esac

  [ "$decision" = "y" ] && {
  	source scripts/setup_gnome.sh
  } || {
  	echo "skipping Gnome customization."
  }
fi

sudo -v
## install nodejs
source scripts/setup_node.sh

## ---- Shell Agnostic Steps -------------------------------
sudo -v

## Python tools, setup changed since 3.12
pipx install tldr yt-dlp

## install rust
source scripts/setup_rust.sh

## install alacritty terminal
source scripts/setup_alacritty.sh

## install/update uv package manager (Python)
source scripts/setup_uv.sh

## install starship prompt
cargo install starship --locked

## install golang
source scripts/setup_golang.sh

# install dev & publishing
source scripts/setup_latex.sh

## install command line utils
source scripts/setup_fzf.sh

# ripgrep, fd, bat, eza, zoxide
cargo install fd-find
cargo install --locked bat
cargo install eza
cargo install zoxide --locked

## ---- utility apps ---------------------------------------
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    source scripts/setup_gnome.sh
fi

source scripts/setup_calibre.sh


## ---- clean up -------------------------------------------

unset _DIST _SHELL _OS GOLANG_DL_STR GOLANG_VER GOLANG_PKG
