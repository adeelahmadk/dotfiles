#!/bin/bash
# First install all languages:
# git, make, python, pip, npm, node, cargo, nvim and golang

if [[ $(id -u) -ne 0 ]]; then
   echo "root permissions required!" 
   sudo -v
   # exit 1
fi

sudo apt install -y \
    htop tree ncdu ranger \ # lm-sensors
    git make curl ripgrep \
    python3-pip python3-venv python3-argcomplete \
    html-xml-utils source-highlight \
    flameshot bleachbit qdirstat

# append color highlight setup to bashrc
cat <<EOF >> ~/.bashrc

# Enable source highlighting in `less` pager (dep: source-highlight)
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R'
EOF

sudo -v

## install pacstall
sudo bash -c "$(curl -fsSL https://pacstall.dev/q/install || wget -q https://pacstall.dev/q/install -O -)"
## install neovim latest from pacstall repo
pacstall -I neovim

sudo -v

## install nodejs
# Node Version Manager (nvm)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install --lts

sudo -v

## Python tools, setup changed since 3.12
## install pip
#curl -fsSL "https://bootstrap.pypa.io/get-pip.py" && python3 get-pip.py
#rm -r ~/.local/pipx/shared
#pip install -U --user pipx

## install rust
[ `command -v rustup` ] && { echo "rust installed! updating..."; rustup update; } || { echo "Installing rust..."; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh }

## install alacritty terminal
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
decision="y"
if command -v "go" > /dev/null; then
  printf "Golang:\nInstalled: %s\nLatest: %s\n" "$(go version | awk '{print $3}')" "$GOLANG_VER" 
  read -p "Continue install (y/n)?" -n1 -r choice
  case "$choice" in 
    y|Y ) decision="y";;
    n|N ) decision="n";;
    * )   decision="n";;
  esac
fi

sudo -v

[ "$decision" = "y" ] && {
  GOLANG_PKG="https://go.dev"$GOLANG_DL_STR
  curl -fsSL "$GOLANG_PKG" -o golang.tar.gz && \
  sudo bash -c "rm -rf /usr/local/go && tar -C /usr/local -xzf golang.tar.gz" && \
  rm golang.tar.gz
} || {
  echo
  echo "skipping golang!"
}

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
    sudo apt install -y texlive texlive-extra-utils texlive-latex-extra texlive-font-utils fonts-font-awesome
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

