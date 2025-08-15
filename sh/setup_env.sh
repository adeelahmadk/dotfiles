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
  	source setup_gnome.sh
  } || {
  	echo "skipping Gnome customization."
  }
fi

sudo -v
## install nodejs
# Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install --lts

## ---- Shell Agnostic Steps -------------------------------

sudo -v

## Python tools, setup changed since 3.12
#rm -r ~/.local/pipx/shared
#pip install -U --user pipx

## install rust
[ `command -v rustup` ] && { echo "rust installed! updating..."; rustup update; } || { echo "Installing rust..."; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh }

## install alacritty terminal
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
cargo install alacritty
# setup icons and launcher entry
[ ! -d "$HOME/.local/share/icons" ] && mkdir -p "$HOME/.local/share/icons"
cp ../alacritty/alacritty-term.svg $HOME/.local/share/icons
[ ! -d "$HOME/.local/share/applications" ] && mkdir -p "$HOME/.local/share/applications"
cp ../alacritty/alacritty.desktop $HOME/.local/share/applications

## install starship prompt
cargo install starship --locked

## install golang
sudo -v

GOLANG_DL_STR=$(curl -s -L "https://go.dev/dl" | grep 'downloadBox.*linux' | awk '{print $4}' | awk -F= '{gsub(/[">]/, "", $2);}{print $2}')
GOLANG_VER=$(echo $GOLANG_DL_STR | awk -F- '{print $1}' | awk -F/ '{print $3}')
GOLANG_VER=${GOLANG_VER%.*}
GOLANG_PKG="https://go.dev"$GOLANG_DL_STR
DLFILE="$HOME/Downloads/golang.tar.gz"

decision="y"
if command -v "go" > /dev/null; then
	printf "Golang:\nInstalled: %s\nLatest: %s\n" "$(go version | awk '{print $3}')" "$GOLANG_VER" 
	read -p "Continue install (y/n)?" -n1 -r choice
	case "$choice" in 
		y|Y ) decision="y";;
		n|N ) decision="n";;
		* )   decision="n";;
	esac

	sudo -v

	[ "$decision" = "y" ] && {
	  curl -fsSL "$GOLANG_PKG" -o $DLFILE && \
	  sudo bash -c "rm -rf /usr/local/go && tar -C /usr/local -xzf $DLFILE" && \
	  rm "$DLFILE"
	} || {
	  echo
	  echo "skipping golang!"
	}
else
	# install golang
	echo "installing golang..."
	sudo -v
	curl -fsSL "$GOLANG_PKG" -o "$DLFILE" && \
		sudo bash -c "tar -C /usr/local -xzf $DLFILE" && \
		rm $DLFILE
	echo "installation complete!"
	exit 0
fi

sudo -v

# install dev & publishing
decision="y"
read -p "Install texlive ([y]/n)?" -n1 -r choice
case "$choice" in 
    y|Y ) decision="y";;
    n|N ) decision="n";;
    * )   decision="n";;
esac
[ "$decision" = "y" ] && {
  if [[ "$_DIST" == "debian" || "$_DIST" == "ubuntu" ]]
    sudo apt install -y texlive texlive-extra-utils texlive-latex-extra texlive-font-utils fonts-font-awesome
  elif [[ "$_DIST" == "asrch" ]]; then
    sudo pacman -S texlive-basic texlive-bin texlive-binextra texlive-latex texlive-fontsrecommended texlive-fontutils
  fi
} || {
  echo
  echo "skipping texlive!"
}

## install command line utils
# fzf
cd $HOME
if [ ! -d ~/.fzf ]
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install
else
  cd ~/.fzf && git pull && ./install
fi
# ripgrep, fd, bat, eza, zoxide
cargo install fd-find
cargo install --locked bat
cargo install eza
cargo install zoxide --locked

## ---- clean up -------------------------------------------

unset _DIST _SHELL _OS GOLANG_DL_STR GOLANG_VER GOLANG_PKG
