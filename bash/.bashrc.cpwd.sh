shopt -s checkwinsize

bash_prompt_command() {
    tinfo="$(basename $SHELL):pts$(basename $(tty))"
    # number of graphic characters
    local gfxlen=15
    # number of spaces
    local spchar=6
    # limit on the length of $PWD
    local pwdmaxlen=${COLUMNS}-${#tinfo}-${gfxlen}-${#USER}-${#HOSTNAME}-${spchar}
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
    # fill remaining spaces with graphic characters
    #local pfillsize=0
    #let pfillsize=${COLUMNS}-${#tinfo}-${gfxlen}-${#NEW_PWD}-${#USER}-${#HOSTNAME}-${spchar}
    #local pfchar="━"
    #pfill=""
    #while [ "$pfillsize" -gt 0 ]
    #do
    #    pfill="$pfill$pfchar"
    #    let pfillsize=${pfillsize}-1
    #done
}

bash_prompt() {
    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # emphasized (bold) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    local UC=$G                 # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    PS1="${EMK}[${UC}\u${EMW} at ${UC}\h${EMK}]${EMW} in ${EMK}[${C}\${NEW_PWD}${EMK}] ${EMW}using ${EMK}[${B}\${tinfo}${EMK}]${NONE}
${EMK}[${NONE}$TITLEBAR\${debian_chroot:+($debian_chroot)} ${UC}\\$ ${EMK}]${NONE} "

    #PS1="╭─[\u@\h:\${NEW_PWD}]──[\${tinfo}]
#╰─[$TITLEBAR\${debian_chroot:+($debian_chroot)} \$ ] "
    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
}
# init it by setting PROMPT_COMMAND
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

# define aliases for frequently used commands
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -Alh'
alias aptud='sudo apt-get update'
alias aptug='sudo apt-get upgrade'
alias aptrm='sudo apt-get remove'
alias aptarm='sudo apt-get autoremove'
alias aptin='sudo apt-get install'
alias apts='apt search'
alias lshosts='sudo nmap -sP -PB'
alias pingg='ping -c 4 8.8.8.8'
