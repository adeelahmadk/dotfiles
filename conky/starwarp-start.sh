#!/bin/bash

[ ! -d "$HOME/.cache/conky" ] && mkdir -p $HOME/.cache/conky
[ -r "$HOME/storage/API/conky.env.sh" ] \
    || { printf "Couldn't load env variables and API key.\nExport vars from a file and place its absolute address at line# ${LINENO} in `basename $0`\n"; exit 1; }
source $HOME/storage/API/conky.env.sh

#conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_clock" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_weather" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_sys" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_os" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_geo" &
#conky -p 2 -c "$HOME/.conky/starwarp/starwarp_news" &

