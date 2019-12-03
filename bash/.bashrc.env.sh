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

function rmd() {
# Read a markdown file in terminal.
# Dependencies: pandoc, lynx
    pandoc $1 | lynx -stdin
}

################################################################
#  Define Aliases
#  for frequently used commands
################################################################

# common commands
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -Alh'
alias llt='ls -lts'
alias lsd='ls -d */'
alias lsf='ls -lh | egrep -v "^d"'

# custom application functions
alias mergepdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged_file.pdf'

# package manager (Debian/Ubuntu)
alias aptud='sudo apt-get update'
alias aptug='sudo apt-get upgrade'
alias aptrm='sudo apt-get remove'
alias aptarm='sudo apt-get autoremove'
alias aptin='sudo apt-get install'
alias apts='apt search'

# system admin commands
alias lsproc='ps -ef | grep'
alias ldsk='mount|& grep /dev/sd|cut -f 1 -d" "|sort'
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

