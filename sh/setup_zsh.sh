#!/usr/bin/bash

set -e

if [[ ! -d "$HOME/.config/zsh" ]]; then
    mkdir -p "$HOME/.config/zsh"
fi

ZSH=$HOME/.config/zsh

GREEN="\e[32m"
RESET="\e[0m"
decision=

if ! command -v zsh > /dev/null; then
	if command -v apt > /dev/null; then
		sudo -v
		apt install -y zsh
	else
		echo "install zsh before setting it up!"
		exit 1
	fi
fi

sudo -v
chsh -s $(command -v zsh)

printf "Plugin mamangement: [Z]im/[${GREEN}M${RESET}]anual?"
read -r choice
case "$choice" in
    m|M ) decision="m";;
    z|Z ) decision="z";;
    * )   decision="m";;
esac

if [[ "$decision" = "m" ]]; then
    ln -s $(pwd)/.zshrc.min.zsh "$HOME/.zshrc"
    mkdir -p "$ZSH/plugins" && pushd "$ZSH/plugins"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git
    git clone https://github.com/zsh-users/zsh-autosuggestions.git
    git clone https://github.com/zsh-users/zsh-completions.git
    popd
elif [[ "$decision" = "z" ]]; then
    ln -s $(pwd)/.zshrc.zim.zsh "$HOME/.zshrc"
fi

ln -s $(pwd)/.zshrc.env.zsh "$ZSH/.zshrc_env"
ln -s $(pwd)/.zshrc.aliases.zsh "$ZSH/.zshrc_aliases"
ln -s $(pwd)/.zshrc.functions.zsh "$ZSH/.zshrc_funcs"

echo "\nzsh is setup successfully,\nPlease logout and login for settings to take effect!"
