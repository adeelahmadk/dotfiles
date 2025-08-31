#!/usr/bin/env bash

[ `command -v rustup` ] && { echo "rust installed! updating..."; rustup update; } || { echo "Installing rust..."; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh }
