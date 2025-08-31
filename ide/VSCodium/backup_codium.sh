#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$CONFIG_DIR/dotfiles/ide/VSCodium"
SOURCE_DIR="$CONFIG_DIR/VSCodium/User"

function backupConfig() {
  if command -v codium > /dev/null; then
    pushd $CONFIG_DIR > /dev/null 
    tar czf "$BACKUP_DIR/vscodium_config.tar.gz" \
      --exclude=workspaceStorage --exclude=History \
      VSCodium/User
    popd > /dev/null
  fi
}

function restoreConfig() {
  [ -d "$SOURCE_DIR" ] && {
    decision=
    read -p "dir already exists! Continue y/[N]?" -n1 -r choice
    case "$choice" in
      y|Y ) decision="y";;
      n|N ) decision="n";;
      * )   decision="n";;
    esac

    [ "$decision" = "n" ] && {
      echo -e "\nSkipping restore!"
      return
    }
    echo
  }

  pushd $CONFIG_DIR > /dev/null 
  tar xzf "$BACKUP_DIR/vscodium_config.tar.gz" \
    -C "$CONFIG_DIR"
  popd > /dev/null
  echo -e "\n\nRestore complete!"
}

function usage() {
  echo "Usage: $0 backup|restore"
}

[ "$#" -gt 1 ] && {
  usage
  exit 1
} 

if [ "$1" == "backup" ]; then
  echo "Backing up VS Codium config..."
  backupConfig
elif [ "$1" == "restore" ]; then
  echo "Restoring VS Codium config..."
  restoreConfig
else
  usage
fi

