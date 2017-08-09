#!/bin/bash

sleep 15s
killall conky

conky -c "$HOME/.conky/.conkyrc_minH" &
