#!/bin/bash

sleep 15s
killall conky

conky -c "~/.conky/.conkyrc_minH" &


