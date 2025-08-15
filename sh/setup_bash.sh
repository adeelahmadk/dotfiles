#!/bin/bash

ln -s $(pwd)/.bashrc.env.zsh "$HOME/.bashrc_env"
ln -s $(pwd)/.bashrc.aliases.zsh "$HOME/.bashrc_aliases"
ln -s $(pwd)/.bashrc.functions.zsh "$HOME/.bashrc_funcs"


cat <<EOF >> ~/.bashrc
### ---- source dotfiles -------------------------------------
if [[ -f ~/.bashrc_env ]]; then
    . ~/.bahrc_env
fi

if [[ -f ~/.bashrc_aliases ]]; then
    . ~/.bashrc_aliases
fi

if [[ -f ~/.bashrc_funcs ]]; then
    . ~/.bashrc_funcs
fi
EOF
