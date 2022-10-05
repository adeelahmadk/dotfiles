#!/bin/bash

source $HOME/storage/API/conky.env.sh
#conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_clock" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_weather" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_sys" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_os" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_geo" &
#conky -p 2 -c "$HOME/.conky/starwarp/starwarp_news" &

