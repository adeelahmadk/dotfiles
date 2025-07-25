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
        tldr "$cmd"
    fi
}
#zle -N run-tldr{,}
zle -N tldr-widget run-tldr
bindkey '^[OP' tldr-widget # Bind F1

insert_sudo() { BUFFER="sudo $BUFFER"; zle end-of-line; }
zle -N insert_sudo
bindkey '\es' insert_sudo # Bind ESC+S

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
    __fzf=$(command -v fzf)
    [ -z "$__fzf" ] && { echo "fzf: command not found!"; return1; }
    local nvim_configs=($(fd --max-depth 1 --glob 'nvim*' ~/.config))
    typeset -A config_paths=()

    for path in ${nvim_configs[@]}; do
        local directory=${path:t} # basename
        title=${directory##*nvim-}
        title=${title/nvim/default}
        config_paths[$title]="$path"
    done

    # Assumes all configs exist in directories named ~/.config/nvim-*
    local config=$(printf "%s\n" ${(k)config_paths[@]} | $__fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
    config=$(${${config_paths[${config}]}##*/}) # basename

    # If I exit fzf without selecting a config, don't open Neovim
    [[ -z $config ]] && echo "No config selected" && return

    # Open Neovim with the selected config
    NVIM_APPNAME=$config nvim $@
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
    delta=0
    __awk=$(which awk) || {
        echo "missing dependency: gawk" >&2
        return 1
    }
    [ "$#" -lt 2 -o "$#" -gt 3 -o ! -r "$1" ] &&
        {
            echo "Usage: nlines FILE <line-number> [delta]" >&2
            return 1
        }
    [ "$#" -eq 2 ] && delta=5 || delta="$3"
    d1=$(($2 - $delta))
    d2=$(($2 + $delta))
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
    __pacman=$(which pacman)
    __awk=$(which awk)
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
    __grep=/usr/bin/grep
    __awk=$(which awk)
    __tac=$(which tac)
    d2=$($__grep -in -m1 -- "$1" "$2" | $__awk -F':' '{print $1}')
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
