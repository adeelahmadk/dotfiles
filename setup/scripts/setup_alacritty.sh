#!/usr/bin/env bash

REPO_BASE=`realpath ../..`
CONFIG_DIR="${REPO_BASE}/alacritty"

export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
cargo install alacritty

# setup icons and launcher entry
[ ! -d "$HOME/.local/share/icons" ] && mkdir -p "$HOME/.local/share/icons"
cp $CONFIG_DIR/alacritty/alacritty-term.svg $HOME/.local/share/icons
[ ! -d "$HOME/.local/share/applications" ] && mkdir -p "$HOME/.local/share/applications"
cp $CONFIG_DIR/alacritty/alacritty.desktop $HOME/.local/share/applications

# symlink config files
ln -s "$CONFIG_DIR" "$HOME/.config/alacritty"
