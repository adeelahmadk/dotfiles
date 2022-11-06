shopt -s checkwinsize

################################################################
#  Setup Prompt
################################################################
function _update_ps1() {
  PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
  PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

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
srand() {
    __date=`which date`
    __cut=`which cut`
    # seed random generator
    RANDOM=$($__date +%s%N | $__cut -b10-19)
}

function rotlog() {
  file="$1"
  MaxFileSize=$((1024*1024))
  file_size=`du -b $file | tr -s '\t' ' ' | cut -d' ' -f1`
  if [ $file_size -ge $MaxFileSize ]; then
    for i in {9..1}; do
      if [[ -f $file.${i} ]]; then
        mv -f $file.${i} $file.$((i+1))
      fi
    done
    mv -f $file $file.1
    touch $file
  fi
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

function rdld() {
    delta=0
    __awk=`which awk` || { echo "missing dependency: gawk" >&2; return 1; }
    [ "$#" -lt 2 -o "$#" -gt 3 -o ! -r "$1" ] && \
        { echo "Usage: rdld FILE <line-number> [delta]" >&2; return 1; }
    [ "$#" -eq 2 ] && delta=5 || delta="$3"
    d1=$(($2 - $delta))
    d2=$(($2 + $delta))
    $__awk -v a=$d1 -v b=$d2 'NR>=a&&NR<=b' "$1"
}

#############################################
# Logs error on stderr.
# Globals:
#   None
# Arguments:
#   An error msg string to log on stderr.
# Returns:
#   None
#############################################
# function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

function readmd() {
# Read a markdown file in terminal.
# Dependencies: pandoc, lynx
    __pandoc=`which pandoc`
    __lynx=`which lynx`
    if [[ -z "$__pandoc" ]] || [[ -z "$__lynx" ]]; then
        echo "Install dependencies: pandoc and lynx."
        return 1
    fi
    $__pandoc $1 | $__lynx -stdin
}

function lld() {
# List directory names in the pwd.
    if [ "$#" -gt 0 ] && [ -d "$1" ]; then
        dest="$1"
    else
        dest="."
    fi
    local __ls=`which ls`
    local __grep=`which grep`
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
    [ "$#" -lt 1 ] && echo "usage: wp2md URI [output_file]" >&2; return 1;
    __awk=`which awk` || echo "missing dependency: awk" >&2; return 1;
    __curl=`which curl` || echo "missing dependency: curl" >&2; return 1;
    __hxnorm=`which hxnormalize` || echo "missing dependency: hxnormalize" >&2; return 1;
    __hxrem=`which hxremove` || echo "missing dependency: hxremove" >&2; return 1;
    __pandoc=`which pandoc` || echo "missing dependency: pandoc" >&2; return 1;
    # prepare url for the printable version
    local url=`echo "${1}" | $__awk -F/ '{print $1 "//" $3 "/w/index.php?title=" $NF "&printable=yes";}'`
    local outfile=
    [ -n "$2" ] && outfile="${2}" || outfile="$(echo $1 | $__awk -F/ '{print $NF;}').md"
    echo "Pulling ${url}"
    $__curl -sS "${url}" | $__hxnorm -x | $__hxrem '.noprint' | $__pandoc -f html -t markdown -o "${outfile}"
}

function fzz() {
    # fuzzy find files in dir tree received.
    find "$1" -type f 2> /dev/null | fzf
}

function fzd() {
    # fuzzy find dirs in dir tree received.
    find "$1" -type d 2> /dev/null | fzf
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
    __awk=`which awk`
    __grep=`which grep`
    __fpack=`which flatpak`
    echo "Searching for the app flatpak remotes..."
    RES=$($__fpack search "$1" | $__grep "$1" | $__awk -F'\t' '{print $NF "-" $3;}')
    IFS=- read REMOTE REF <<< $RES
    echo "Looking up REF:${REF} in REMOTE:${REMOTE}..."
    $__fpack remote-info $REMOTE $REF || echo "flatpak remote-info failed!" >&2
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
    __aptcache=`which apt-cache`
    __awk=`which awk`
    # __grep=`which grep`
    $__aptcache show "$1" | \
        $__awk '/Package:/ {print} /Version:/ {print} /Description.*:/ {p=1} /Description-md5/ {p=0;exit}p;'
}


################################################################
#  Define Env Vars
#  for frequently used paths etc.
################################################################
# set env vars for virtualenv
export VENV=$HOME/workspace/venv

################################################################
#  Define Aliases
#  for frequently used commands
################################################################

# common commands
alias ls='ls --color=auto'
alias la='ls -A'
alias dls='ls --group-directories-first'
alias dla='ls -A --group-directories-first'
alias lsd='ls -d */'
alias ll='ls -lh --group-directories-first'
alias lla='ls -Alh'
alias lt='ls -lth'
alias lu='ls -ltuh'
alias lsf='ls -lh | egrep -v "^d"'

# custom application functions
alias mergepdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged_file.pdf'

# package management (apt, flatpak)
alias aptud='sudo apt update'
alias aptug='sudo apt upgrade'
alias aptrm='sudo apt remove'
alias aptarm='sudo apt autoremove'
alias aptin='sudo apt install'
alias aptls='apt list --upgradable'
alias apts='apt search'
alias fpls='flatpak list'
alias fpud='flatpak update -y'
alias fpcl='flatpak uninstall --unused -y'
alias update='sudo sh -c "apt update && apt upgrade -y && apt autoremove -y"'
alias updall='sudo sh -c "apt update && apt upgrade -y && apt autoremove -y" && flatpak update -y && flatpak uninstall --unused -y'

# searching
alias whatigot="dpkg --get-selections | grep install | cut -f1"

# dev env commands
alias asin="as -msyntax=intel -mnaked-reg"
alias lzyd="lazydocker"
alias lzyg="lazygit"

# system admin commands
alias lsproc='ps -ef | grep'
alias ldsk='mount|grep /dev/sd|cut -f1-3 -d" "|sort'
alias usage='du -hxd1'
alias dsz='du -hxd0'
alias filesfx='echo `date "+%F"`_`date "+%s"`'
alias rmspc='find -name "* *" -type f | rename "s/ /_/g"'

# network admin commands
alias lshosts='fping -aAqgn -r 0'
alias scansub='sudo nmap -sP -PB'
alias pingg='ping 8.8.8.8 -c'
alias intip="ifconfig `route -n | grep -m1 -e ^'0\.0\.0\.0' |awk '{print \$NF}'` | grep 'inet ' | awk '{print \$2}' | sed 's/addr://1'"
alias pubip='curl -s "https://api.ipify.org" ; echo'
alias hdrchk='curl -o /dev/null --max-time 3 --silent --write-out "HTTP Status: %{http_code}\n"'
alias lslp='netstat -lntup'

# docker command aliases
alias doci="docker image"
alias docc="docker container"
alias docv="docker volume"

## dev env on-liners
alias repos="find . -name .git -type d -prune -exec dirname {} \;"
