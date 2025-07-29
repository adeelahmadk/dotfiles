# BASH Aliases and Functions

## Scripts

| File | Description |
| -------- | ----------- |
| `.bashrc.cpwd.sh` | bash config for custom prompt |
| `.bashrc.aliases.sh` | define aliases for bash environment  |
| `.bashrc.functions.sh` | define functions as complex commands for bash environment |
| `.bashrc.env.sh` | define env vars for bash  |
| `setup_init.sh` | Setup some basic apps for a new Debian/Ubuntu system |
| `setup_env.sh` | Setup a dev env for a new system (for Debian/Ubuntu/Arch) |
| `.zshrc.min.zsh` | minimal `zsh` configuration |
| `.zshrc.min.zsh` | a relatively robust `zsh` configuration using `zim` framework |
| `.zshrc.env.sh` | paths and env vars |
| `.zshrc.aliases.sh` | aliases |
| `.zshrc.functions.sh` | functions and `zle` widgets for task automation |
| `setup_zsh.sh` | a script to setup the `zsh` configuration |
| `themecli` | light/dark theme swticher for alacritty & vim |
| `themegtk` | theme switcher for gtk |
| `themepop` | light/dark theme switcher for Pop OS (<=22.04, Pop Shell) |

## BASH Aliases

Bash script `.aliases.env.sh` defines a number of one-liners as aliases to simplify performing frequent tasks.

### File & Directories

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| dls |  | list with directories first |
| dla |  | list all with directories first |
| lsd |  | list directories |
| lt |  | long list sorted by modification time descending |
| lu |  | long list, sort by and show access time |
| lsf |  | long list directories only |

### Package Management

#### APT

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| aud |  | update apt cache |
| aug |  | install upgrades available in upstream repo |
| aprm | `aprm PACKAGE` | remove apt managed package |
| a2rm |  | auto remove apt managed package |
| aptin | `aptin PACKAGE` | install an apt managed package |
| aptls |  | list upgradable packages, use after `apt update` |
| apts | `apts KEYWORD` | search an apt managed package |
| fpls |  | list info for a flatpak package |
| fpud |  | upgrade all flatpak packages |
| fpcl |  | remove flatpak packages not required |
| upd |  | upgrade all apt packages |
| upall |  | upgrade all system packages (apt + flatpak) |
| whatigot |  | list all of my apt packages |

### System Admin

System tasks

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| lsproc | `lsproc KEYWORD` | list processes matching a keyword |
| ldsk |  | list disk mount points |
| usage | `udage [dir]` | space used by dirs under a root dir |
| dsz | `dsz [dir]` | space used by a dir |
| filesfx |  | generate a date & time suffix for unique file names |
| rmspc | `rmspc` | replace space with underscores in a dir's file names |
|  |  |   |

Network tasks

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| wlsig |  | print wireless signal strength |
| lshosts | `lshosts RANGE` | fping: scan and list hosts in an IP range '192.168.19.10-120' |
| scansub | `scansub SUBNET` | nmap: scan a subnet '192.168.19.0/24' |
| pingg | `pingg n` | ping google n times |
| intip |  | show internal IP |
| pubip |  | show public ip |
| hdrchk | `hdrchk URL` | get http status code for a URL |
| lslp |  | list open ports |
|  |  |  |

### Applications

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| mergepdf |  | merge a list of pdf files into a single file |

### Development

| Alias | Usage | Description |
| -------- | ----- | ----------- |
| asin |  | GNU assembler: assemble in intel syntax |
| lzyd |  | lazydocker |
| lzyg |  | lazygit |
| gss |  | git stat summary |
| glp1 |  | git online log |
| ggr |  | go to git repo's root |
| repos |  | list git repos under PWD |
| doci |  | docker image |
| docc |  | docker container |
| docv |  | docker volume |
|  |  |  |

## Shell Functions

Shell script `.bashrc.functions.sh` and `.zshrc.functions.sh` define a number of functions to simplify performing frequent tasks.

| Function | Args  | Shell | Description |
| -------- | ----- | ----------- | -------- |
| `readmd` | `FILE` | `bash` | Read a markdown file in the terminal |
| `wp2md` | `URL [FILE]` | `bash` | Generate markdown doc from Wikipedia article |
| `lld` | `[dir]` | `bash` | List directory names in the pwd. |
| `log_error` | `msg` | `bash` | Logs an error message string on stderr |
| `srand`  |  | `bash` | Seed the 16-bit random number generator |
| `rotlog` | `LOGFILE` | `bash` | Rotates a log file every 1MB |
| `vv` | `FILE` | `bash`, `zsh` | Gives a menu to select from nvim configs |
| `nlines` | `FILE <line-number> [delta]` | `bash`, `zsh` | Reads +/-delta from nth line in a file |
| `fzz` | `[dir]` | `bash`, `zsh` | Fuzzy find files |
| `fdd` | `[dir]` | `bash`, `zsh` | Fuzzy find directories |
| `aptdesc` | `pkg-name` | `bash` | Print info about an apt package |
| `pacdesc` | `pkg-name` | `zsh` | Print info about a package |
| `envon` | `VENVNAME` | `bash` | Activate a Python venv saved in a default home directory. |
| `envls` |  | `bash` | List all python venv's saved in a default home directory |
| `fpfind` | `KEYWORD` | `bash` | Search and print info about a remote flatpak application or runtime |
| `wlwch` |  | `bash`, `zsh` | Watch WiFi signal strength every n seconds |
| `vwt` | `KEYWORD FILE` | `bash`, `zsh` | Open a file at the first appearance of a keyword at top screen |
| `vwm` | `KEYWORD FILE` | `bash`, `zsh` | Open a file at the first appearance of a keyword at mid screen |
| `shdoc` | `FUNCTION FILE` | `bash`, `zsh` | Search and print doc comment (Google Style) of a function in a script file. |
|  |  |  |  |
