#!/usr/bin/env bash

# fzf
pushd $HOME
if [ ! -d ~/.fzf ]
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install
else
  cd ~/.fzf && git pull && ./install
fi
popd
