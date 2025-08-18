# Config Backup

## Gnome Shell

| File                             | Dconf Path                     |
| -------------------------------- | ------------------------------ |
| `gnome-shell-ext.conf`           | `/org/gnome/shell/extensions/` |
| `gnome-shell-backup-trixie.conf` | `/org/gnome/shell/`            |

**Backup** your config using:

```shell
dconf dump /org/gnome/shell/extensions/ > gnome-shell-ext.conf
```

and **restore** using:

```shell
dconf load /org/gnome/shell/extensions/ < gnome-shell-ext.conf
```

