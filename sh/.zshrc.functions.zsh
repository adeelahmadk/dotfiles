# Set env vars
export EDITOR=nvim

## --- zsh keybindings -------------------------------------

function run-tldr() {
    local line="$BUFFER"
    local cmd
    cmd="$(echo "$line" | head -n1 | awk '{print $1;}')"
    if [ -n "$cmd" ]
    then
        zle -I
        echo "fetching help..."
        tldr "$cmd"
    fi
}
zle -N tldr-widget run-tldr
bindkey '^[OP' tldr-widget # Bind F1

function run-tldr-from-cursor() {
    local line="$RBUFFER"
    local cmd
    cmd="$(echo "$line" | head -n1 | awk '{print $1;}')"
    if [ -n "$cmd" ]
    then
        zle -I
        echo "fetching help..."
        tldr "$cmd"
    fi
}
zle -N run-tldr-from-cursor
bindkey '^[[1;2P' run-tldr-from-cursor # Bind Shift+F1

insert_sudo() {
    zle beginning-of-line;
    BUFFER="sudo $BUFFER";
    zle end-of-line;
}
zle -N insert_sudo
bindkey '\es' insert_sudo # Bind ESC+S

bindkey '^[[H' beginning-of-line # Bind Home

bindkey '^[[F' end-of-line # Bind END

bindkey '^[[1;5D' backward-word # Bind Ctrl+Left

bindkey '^[[1;5C' forward-word # Bind Ctrl+Right

bindkey '^[[3~' delete-char-or-list # Bind Delete

## ---- utility functions ----------------------------------

#############################################
# Launch a nvim config of choice
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#############################################
vv() {
    local __fzf=$(command -v fzf)
    local __nvim=$(command -v nvim)
    local __fd=$(command -v fd)
    echo "$__fzf"
    [ -z "$__fzf" ] && { echo "fzf: command not found!"; return 1; }
    local nvim_configs=($($__fd --max-depth 1 --glob 'nvim*' ~/.config))
    typeset -A config_paths=()

    for nvim_conf in ${nvim_configs[@]}; do
        local directory=${nvim_conf:t} # basename
        title=${directory##*nvim-}
        title=${title/nvim/vanilla}
        config_paths[$title]="$nvim_conf"
    done

    nvim_conf=""

    # Assumes all configs exist in directories named ~/.config/nvim-*
    local config=$(printf "%s\n" ${(k)config_paths[@]} | $__fzf --prompt="Neovim Config > " --height=~50% --layout=reverse --border --exit-0)
    config="${config_paths[${config}]}"
    config="${config:t}" # basename

    # If I exit fzf without selecting a config, don't open Neovim
    [[ -z $config ]] && echo "No config selected" && return

    # Open Neovim with the selected config
    export NVIM_APPNAME="$config"
    $__nvim $@
    unset NVIM_APPNAME
}

#############################################
# Reads +/-delta from nth line in a file
# Globals:
#   None
# Arguments:
#   A file name.
#   A line number.
#   An integer delta.
# Returns:
#   None
#############################################
function nlines() {
    local delta=0
    local __awk=$(command -v awk) || {
        echo "missing dependency: gawk" >&2
        return 1
    }
    [ "$#" -lt 2 -o "$#" -gt 3 -o ! -r "$1" ] &&
        {
            echo "Usage: nlines FILE <line-number> [delta]" >&2
            return 1
        }
    [ "$#" -eq 2 ] && delta=5 || delta="$3"
    local d1=$(($2 - $delta))
    local d2=$(($2 + $delta))
    $__awk -v a=$d1 -v b=$d2 'NR>=a&&NR<=b' "$1"
}

###############################################
# Fuzzy find files or directories
# Globals:
#   None
# Arguments:
#   Target directory
# Returns:
#   None
###############################################
function fzz() {
    # fuzzy find files in dir tree received.
    find "$1" -type f 2>/dev/null | fzf
}

function fzp() {
    # fuzzy find files in dir tree with highlighted preview (bat).
    find "$1" -type f 2>/dev/null | fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"
}

function fzd() {
    # fuzzy find dirs in dir tree received.
    find "$1" -type d 2>/dev/null | fzf
}

###################################################
# Open a file at the first appearance of a keyword
# and align it at the top of the buffer
#
# Globals:
#   None
# Arguments:
#   keyword
#   file name
# Returns:
#   None
###################################################
function vwt() {
    [ "$#" -ne 2 ] && {
        echo "Usage: vwf KEYWORD FILE" >&2
        return 1
    }
    [ ! -f "$2" ] && {
        echo "Not a valid file: ${2}" >&2
        return 1
    }

    # allign to the top of the screen
    nvim +$(grep -in -m1 "$1" "$2" | awk -F':' '{print $1}') -c 'execute "normal zt"' "$2"
}

###################################################
# Open a file at the first appearance of a keyword
# and align it at the center of the buffer
#
# Globals:
#   None
# Arguments:
#   keyword
#   file name
# Returns:
#   None
###################################################
function vwm() {
    [ "$#" -ne 2 ] && {
        echo "Usage: vwm KEYWORD FILE" >&2
        return 1
    }
    [ ! -f "$2" ] && {
        echo "Not a valid file: ${2}" >&2
        return 1
    }

    # allign to the middle of the screen
    nvim +$(grep -in -m1 "$1" "$2" | awk -F':' '{print $1}') -c 'execute "normal zz"' "$2"
}

###############################################
# Search and print info about a package in
# arch repo
#
# Globals:
#   None
# Arguments:
#   A string keyword to search
# Returns:
#   None
###############################################
function pacdesc() {
    [ "$#" -ne 1 ] && echo "Usage: pacdesc PACKAGE" >&2 && return 2
    local __pacman=$(command -v pacman)
    local __awk=$(command -v awk)
    $__pacman -Si "$1" |
        $__awk '/Name/ {print} /Version/ {print} /Description.*/ {p=1} /Architecture/ {p=0;exit}p;'
}

###############################################
# Search and print docstring of a function in
# a shell script.
#
# Globals:
#   None
# Arguments:
#   A string keyword to search
#   A script file to search in
# Returns:
#   None
###############################################
function shdoc() {
    [ "$#" -ne 2 ] && {
        echo "Usage: shdoc KEYWORD FILE" >&2
        return 2
    }
    [ ! -f "$2" ] && {
        echo "File: $2 not found!" >&2
        return 2
    }
    local __grep=$(command -v grep)
    local __awk=$(command -v awk)
    local __tac=$(command -v tac)
    local d2=$($__grep -in -m1 -- "$1" "$2" | $__awk -F':' '{print $1}')
    [ -z "$d2" ] && {
        echo "Function $1 not found!" >&2
        return 2
    }
    [ $d2 -gt 20 ] && d1=$(($d2 - 20)) || d1=1
    d2=$(($d2 - 1))
    printf "%s:\n\n" "$1"
    $__awk -v a=$d1 -v b=$d2 'NR>=a&&NR<=b' "$2" |
        $__tac |
        $__awk -F'# ' -v start=1 '/####/{n++;next};n==start{print $2};n==start+1{exit}' |
        $__tac
}

###############################################
# Print internal ip address for the default
# interface.
#
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   IP adress to STDOUT
###############################################
function intip() {
  ip addr show $(ip route | awk '/default/ { print $5 }') \
    | awk '/inet / {print $2}' \
    | cut -d/ -f1
}
function intip6() {
  ip -6 addr show $(ip route | awk '/default/ { print $5 }') \
    | grep -E '^.*inet6' \
    | awk '{print $2}' \
    | cut -d/ -f1
}
