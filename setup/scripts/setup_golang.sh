#!/usr/bin/env bash

sudo -v

GOLANG_DL_STR=$(curl -s -L "https://go.dev/dl" | grep 'downloadBox.*linux' | awk '{print $4}' | awk -F= '{gsub(/[">]/, "", $2);}{print $2}')
GOLANG_VER=$(echo $GOLANG_DL_STR | awk -F- '{print $1}' | awk -F/ '{print $3}')
GOLANG_VER=${GOLANG_VER%.*}
GOLANG_PKG="https://go.dev"$GOLANG_DL_STR
DLFILE="$HOME/Downloads/golang.tar.gz"

decision="y"
if command -v "go" > /dev/null; then
	printf "Golang:\nInstalled: %s\nLatest: %s\n" "$(go version | awk '{print $3}')" "$GOLANG_VER"
	read -p "Continue install (y/n)?" -n1 -r choice
	case "$choice" in
		y|Y ) decision="y";;
		n|N ) decision="n";;
		* )   decision="n";;
	esac

	sudo -v

	[ "$decision" = "y" ] && {
	  curl -fsSL "$GOLANG_PKG" -o $DLFILE && \
	  sudo bash -c "rm -rf /usr/local/go && tar -C /usr/local -xzf $DLFILE" && \
	  rm "$DLFILE"
	} || {
	  echo
	  echo "skipping golang!"
	}
else
	# install golang
	echo "installing golang..."
	sudo -v
	curl -fsSL "$GOLANG_PKG" -o "$DLFILE" && \
		sudo bash -c "tar -C /usr/local -xzf $DLFILE" && \
		rm $DLFILE
	echo "installation complete!"
	exit 0
fi
