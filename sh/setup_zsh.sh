#!/usr/bin/zsh

if [[ ! -d "$HOME/.config/zsh" ]]; then
    mkdir -p "$HOME/.config/zsh"
fi

ZSH=$HOME/.config/zsh

GREEN="\e[32m"
RESET="\e[0m"
decision=

printf "Plugin mamangement: [Z]im/[${GREEN}M${RESET}]anual?"
read -r choice
case "$choice" in
    m|M ) decision="m";;
    z|Z ) decision="z";;
    * )   decision="m";;
esac

if [[ "$decision" = "m" ]]; then
    ln -s $(pwd)/.zshrc.min.zsh "$HOME/.zshrc"
elif [[ "$decision" = "z" ]]; then
    ln -s $(pwd)/.zshrc.zim.zsh "$HOME/.zshrc"
fi

ln -s $(pwd)/.zshrc.env.sh "$ZSH/.zshrc_env"
ln -s $(pwd)/.zshrc.aliases.sh "$ZSH/.zshrc_aliases"
ln -s $(pwd)/.zshrc.functions.sh "$ZSH/.zshrc_funcs"
