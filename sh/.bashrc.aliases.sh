# aliases for utility shell commands.

################################################################
#  Setup Prompt
################################################################
function _update_ps1() {
  PS1=$(powerline-shell $?)
}

# if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#   PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# fi

################################################################
# Set env variables
################################################################
# '--height 40% --layout=reverse --border'
command -v fzf > /dev/null \
    && export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# color highlghting for `less`
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

################################################################
#  Setup dev environments
################################################################
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

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
alias lla='ls -Alh --group-directories-first'
alias lt='ls -lth --group-directories-first'
alias lu='ls -ltuh --group-directories-first'
alias lsf='ls -lh | egrep -v "^d"'

## custom application functions
alias mergepdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=merged_file.pdf'

## package management (apt, flatpak)
# apt
alias aud='sudo sh -c "apt update"'
alias aug='sudo sh -c "apt upgrade"'
alias aprm='sudo sh -c "apt remove"'
alias a2rm='sudo sh -c "apt autoremove"'
alias aptin='sudo sh -c "apt install"'
alias aptls='apt list --upgradable'
alias apts='apt search'
alias upd='sudo sh -c "apt update && apt upgrade -y && apt autoremove -y"'
# nala
alias nls='nala list --upgradable'
alias nf='nala search'
alias nup='sudo sh -c "nala upgrade -y && nala autoremove -y"'
# flatpak
alias fpls='flatpak list'
alias fpud='flatpak update -y'
alias fpcl='flatpak uninstall --unused -y'
# upgrade from all managers
alias upall='sudo sh -c "apt update && apt upgrade -y && apt autoremove -y" && flatpak update -y && flatpak uninstall --unused -y'
# apt upadte count
alias upc='echo "$(apt-get -q -y --allow-change-held-packages --allow-unauthenticated -s dist-upgrade 2>/dev/null | grep ^Inst | wc -l) update(s) avaiable"'
# package searching
alias whatigot="dpkg --get-selections | grep install | cut -f1"
alias aptman="comm -12 <(dpkg --get-selections | grep install | cut -f1 | sort) <(apt-mark showmanual | sort)"

# system admin commands
alias lsproc='ps -ef | grep'
alias ldsk='mount|grep /dev/sd|cut -f1-3 -d" "|sort'
alias usage='du -hxd1'
alias dsz='du -hxd0'
alias filesfx='echo `date "+%F"`_`date "+%s"`'
alias rmspc='find -name "* *" -type f | rename "s/ /_/g"'
alias fnorm='for f in *\ *; do mv "$f" "${f// /_}"; done'
alias nvs='watch -n 2 nvidia-smi'

# network admin commands
alias wlsig="nmcli device wifi | awk -f $HOME/.config/scripts/wlsig.awk"
alias lshosts='fping -aAqgn -r 0'
alias scansub='sudo nmap -sP -PB'
alias pingg='ping 8.8.8.8 -c'
alias intip="ifconfig `route -n | grep -m1 -e ^'0\.0\.0\.0' |awk '{print \$NF}'` | grep 'inet ' | awk '{print \$2}' | sed 's/addr://1'"
alias pubip='curl -s "https://api.ipify.org" ; echo'
alias hdrchk='curl -o /dev/null --max-time 3 --silent --write-out "HTTP Status: %{http_code}\n"'
alias lslp='netstat -lntup'

# dev env commands
alias asin="as -msyntax=intel -mnaked-reg"
alias lzyd="lazydocker"
alias lzyg="lazygit"

# dict commands
alias defc="dict -d foldoc"
alias defwn="dict -d wn"
alias defmob="dict -d moby-thesaurus"

# vcs command aliases
alias gits="git status"
alias gaa="git add ."
alias gss="git log --stat --summary"
alias glp1="git log --pretty=oneline"
alias ggr="git rev-parse --show-toplevel>/dev/null 2>&1 && cd \$(git rev-parse --show-toplevel) || ( echo 'Not a git repo!'; exit 1; )"

## dev env one-liners
alias repos="find . -name .git -type d -prune -exec dirname {} \;"

# docker command aliases
alias doci="docker image"
alias docc="docker container"
alias docv="docker volume"

# open local dev sites incognito
alias chd="google-chrome --incognito"

