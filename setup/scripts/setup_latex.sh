#!/usr/bin/env bash

sudo -v

decision="y"
read -p "Install texlive ([y]/n)?" -n1 -r choice
case "$choice" in
    y|Y ) decision="y";;
    n|N ) decision="n";;
    * )   decision="n";;
esac
[ "$decision" = "y" ] && {
  sudo -v
  if [[ "$_DIST" == "debian" || "$_DIST" == "ubuntu" ]]
    sudo apt install -y texlive texlive-extra-utils texlive-latex-extra texlive-font-utils fonts-font-awesome
  elif [[ "$_DIST" == "asrch" ]]; then
    sudo pacman -S texlive-basic texlive-bin texlive-binextra texlive-latex texlive-fontsrecommended texlive-fontutils
  fi
} || {
  echo
  echo "skipping texlive!"
}
