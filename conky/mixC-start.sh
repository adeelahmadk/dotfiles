#!/bin/bash

[ ! -d "$HOME/.cache/conky" ] && mkdir -p $HOME/.cache/conky
[ -r ".env" ] \
    || { printf "Couldn't load env variables and API key.\nExport vars from a file and place its absolute address at line# ${LINENO} in `basename $0`\n"; exit 1; }
source .env

conky -c "$HOME/.conky/mixC/conkyrc_mixC12" &
conky -c "$HOME/.conky/mixC/conkyrc_mixC13" &
conky -c "$HOME/.conky/mixC/conkyrc_mixC14" &
