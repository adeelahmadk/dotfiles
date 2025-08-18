# Config Backup

## Gnome Shell

Backup your config using:

```shell
dconf dump /org/gnome/shell/extensions/ > gnome-shell-ext.conf
```

Restore using:

```shell
dconf load /org/gnome/shell/extensions/ < gnome-shell-ext.conf
```

