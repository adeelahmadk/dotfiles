#!/bin/bash

conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_sys" &
# conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_clock" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_weather" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_os" &
conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_geo" &
# conky -p 2 -c "$HOME/.config/conky/starwarp/starwarp_light_rss" &

