shopt -s checkwinsize

################################################################
#  Define Functions
################################################################

#############################################
# Logs error on stderr.
# Globals:
#   None
# Arguments:
#   An error msg string to log on stderr.
# Returns:
#   None
#############################################
function log_error() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#############################################
# Seed the 16-bit random number generator.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#############################################
function srand() {
    __date=$(which date)
    __cut=$(which cut)
    # seed random generator
    RANDOM=$($__date +%s%N | $__cut -b10-19)
}

#############################################
# Get a randomly generated string ofspecific
# specific length.
# Globals:
#   None
# Arguments:
#   length
# Returns:
#   None
#############################################
function randstr() {
    __head=$(which head)
    __tr=$(which tr)
    __fold=$(which fold)
    __awk=$(which awk)
    # seed random generator
    srand
    WIDTH="$1"
    COUNT=$((WIDTH * 4))
    LINENUM=$(((RANDOM % 100) + 1))
    $__head -$COUNT /dev/urandom |
        $__tr -dc 'a-z0-9' |
        $__fold -w $WIDTH |
        $__awk -v n=$LINENUM 'NR==n'
}

#############################################
# Rotate a log file if exceeding 1MB size and
# keep history of 9 files
# Globals:
#   None
# Arguments:
#   A log file name
# Returns:
#   None
#############################################
function rotlog() {
    file="$1"
    MaxFileSize=$((1024 * 1024))
    file_size=$(du -b $file | tr -s '\t' ' ' | cut -d' ' -f1)
    if [ $file_size -ge $MaxFileSize ]; then
        for i in {9..1}; do
            if [[ -f $file.${i} ]]; then
                mv -f $file.${i} $file.$((i + 1))
            fi
        done
        mv -f $file $file.1
        touch $file
    fi
}

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
    local nvim_configs=($(fd --max-depth 1 --glob 'nvim*' ~/.config))
    declare -A config_paths

    for path in ${nvim_configs[@]}; do
        local directory=$(basename $path)
        title=${directory##*nvim-}
        title=${title/nvim/default}
        config_paths[$title]="$path"
    done

    # Assumes all configs exist in directories named ~/.config/nvim-*
    local config=$(printf "%s\n" ${!config_paths[@]} | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
    config=$(basename ${config_paths[${config}]})

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

#############################################
# Read a markdown file in terminal.
# Globals:
#   None
# Arguments:
#   Path to a md file.
# Returns:
#   None
#############################################
function readmd() {
    # Dependencies: pandoc, lynx
    __pandoc=$(which pandoc)
    __lynx=$(which lynx)
    if [[ -z "$__pandoc" ]] || [[ -z "$__lynx" ]]; then
        echo "Install dependencies: pandoc and lynx."
        return 1
    fi
    $__pandoc $1 | $__lynx -stdin
}

#############################################
# List directories under a directory.
# Globals:
#   None
# Arguments:
#   A dirstory
# Returns:
#   None
#############################################
function lld() {
    if [ "$#" -gt 0 ] && [ -d "$1" ]; then
        dest="$1"
    else
        dest="."
    fi
    local __ls=$(which ls)
    local __grep=$(which grep)
    $__ls -lth "$dest" | $__grep -e '^d'
}

###############################################
# Generate markdown doc from Wikipedia article
# Globals:
#   None
# Arguments:
#   URL to the article
#   [FILENAME]
# Returns:
#   None
###############################################
function wp2md() {
    [ "$#" -lt 1 ] && echo "usage: wp2md URI [output_file]" >&2
    return 1
    __awk=$(which awk) || echo "missing dependency: awk" >&2
    return 1
    __curl=$(which curl) || echo "missing dependency: curl" >&2
    return 1
    __hxnorm=$(which hxnormalize) || echo "missing dependency: hxnormalize" >&2
    return 1
    __hxrem=$(which hxremove) || echo "missing dependency: hxremove" >&2
    return 1
    __pandoc=$(which pandoc) || echo "missing dependency: pandoc" >&2
    return 1
    # prepare url for the printable version
    local url=$(echo "${1}" | $__awk -F/ '{print $1 "//" $3 "/w/index.php?title=" $NF "&printable=yes";}')
    local outfile=
    [ -n "$2" ] && outfile="${2}" || outfile="$(echo $1 | $__awk -F/ '{print $NF;}').md"
    echo "Pulling ${url}"
    $__curl -sS "${url}" | $__hxnorm -x | $__hxrem '.noprint' | $__pandoc -f html -t markdown -o "${outfile}"
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

###############################################
# Watch wifi signal strength refreshing after
# n seconds.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
###############################################
function wlwch() {
    watch -n 2 'nmcli device wifi | awk -f $HOME/.config/scripts/wlsig.awk'
}

###############################################
# Search and print info about an apt package
#
# Globals:
#   None
# Arguments:
#   A string keyword to search
# Returns:
#   None
###############################################
function aptdesc() {
    [ "$#" -ne 1 ] && echo "Usage: aptdesc PACKAGE" >&2 && return 2
    __aptcache=$(which apt-cache)
    __awk=$(which awk)
    $__aptcache show "$1" |
        $__awk '/Package:/ {print} /Version:/ {print} /Description.*:/ {p=1} /Description-md5/ {p=0;exit}p;'
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

################################################################
#  Define Env Vars
#  for frequently used paths etc.
################################################################
# set env vars for virtualenv
export VENV=$HOME/workspace/venv

###############################################
# Activate a python venv saved in a default
# home directory.
# Globals:
#   VENV  Path to the venv home directory.
# Arguments:
#   Name of a directory containing a venv
# Returns:
#   None
###############################################
function envon() {
    [ -z "$VENV" ] && {
        echo "Default path to the venv direvtory not defined!"
        return 1
    }
    [ "$#" -ne 1 ] && {
        echo "usage: envon <venv-name>"
        return 1
    }
    envdir="$VENV/$1"
    [ ! -d "$envdir" ] &&
        {
            echo "$envdir: no such directory found!"
            return 1
        }
    [ ! -f "$envdir/bin/activate" ] &&
        {
            echo "$1: missing script file!"
            return 1
        }

    source $envdir"/bin/activate"
}

###############################################
# List all python venv's saved in a default
# home directory.
# Globals:
#   $VENV  Path to the venv home directory.
# Arguments:
#   None
# Returns:
#   None
###############################################
function envls() {
    [ -z "$VENV" ] && {
        echo "Default path to the venv direvtory not defined!"
        return 1
    }
    echo "venv(s) defined at the default path:"
    ls -lh --group-directories-first "$VENV/"
}

###############################################
# Search and print info about a remote flatpak
# application or runtime.
# Globals:
#   None
# Arguments:
#   A string keyword to search
# Returns:
#   None
###############################################
function fpfind() {
    [ "$#" -eq 0 ] && echo "Usage: fpfind APP" >&2 && return 2
    __awk=$(which awk)
    __grep=$(which grep)
    __fpack=$(which flatpak)
    echo "Searching for the app flatpak remotes..."
    RES=$($__fpack search "$1" | $__grep -i "$1" | $__awk -F'\t' '{print $NF "-" $3;}')
    IFS=- read REMOTE REF <<<$RES
    echo "Looking up REF:${REF} in REMOTE:${REMOTE}..."
    $__fpack remote-info --user $REMOTE $REF || echo "flatpak remote-info failed!" >&2
}

###############################################
# Search and print docstring of a function in
# a shell script.
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
    __grep=$(which grep)
    __awk=$(which awk)
    __tac=$(which tac)
    d2=$($__grep -in -m1 -- "$1" "$2" | $__awk -F':' '{print $1}')
    [ -z "$d2" ] && {
        echo "Function $1 not found!" >&2
        return 2
    }
    [ $d2 -gt 20 ] && d1=$(($d2 - 20)) || d1=1
    d2=$(($d2 - 1))
    printf "Docstring for %s:\n\n" "$1"
    $__awk -v a=$d1 -v b=$d2 'NR>=a&&NR<=b' "$2" |
        $__tac |
        $__awk -F'# ' -v start=1 '/####/{n++;next};n==start{print $2};n==start+1{exit}' |
        $__tac
}
