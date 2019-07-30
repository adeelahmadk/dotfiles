#!/bin/bash

sleep 10s
killall conky

conky -c "$HOME/.conky/.conkyrc_mixC12" &
conky -c "$HOME/.conky/.conkyrc_mixC13" &
conky -c "$HOME/.conky/.conkyrc_mixC14" &
