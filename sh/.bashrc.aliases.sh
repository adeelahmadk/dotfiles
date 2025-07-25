# aliases for utility shell commands.

################################################################
# Set env variables
################################################################
# '--height 40% --layout=reverse --border'
command -v fzf >/dev/null &&
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type=d --hidden --strip-cwd-prefix --exclude .git'

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export | unset) fzf --preview "eval 'echo $'{}" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

# color highlghting for `less`
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '

################################################################
#  Setup dev environments
################################################################
#export PYENV_ROOT="$HOME/.pyenv"
#command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"

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
alias tdp='tree --dirsfirst -F'

# ---- Eza (better ls) -----

alias ez="eza --color=always --group-directories-first --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ea="eza --color=always --group-directories-first --no-filesize --icons=always --no-time --no-user --no-permissions -A"
alias el="eza --color=always --group-directories-first --long --git --icons=always --header"
alias ela="eza --color=always --group-directories-first --long --git --icons=always --header -A"
alias ee="eza --color=always --group-directories-first --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ee="eza --color=always --group-directories-first --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -A"
alias et="eza --color=always --group-directories-first --tree --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias elt="eza --color=always --group-directories-first --long --tree --git --icons=always --hyperlink --header"

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
alias nuls='nala list --upgradable'
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

## seraching
alias fzb='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# networks
alias wlsig="nmcli device wifi | awk -f $HOME/.config/scripts/wlsig.awk"
alias lshosts='fping -aAqgn -r 0'
alias scansub='sudo nmap -sP -PB'
alias pingg='ping 8.8.8.8 -c'
alias intip="ifconfig $(route -n | grep -m1 -e ^'0\.0\.0\.0' | awk '{print $NF}') | grep 'inet ' | awk '{print \$2}' | sed 's/addr://1'"
alias pubip='curl -s "https://api.ipify.org" ; echo'
alias hdrchk='curl -o /dev/null --max-time 3 --silent --write-out "HTTP Status: %{http_code}\n"'
alias lslp='netstat -lntup'

# weather update
alias weather="curl -i wttr.in"

# #################
# dev env commands
# #################

# load nvim with custom configs
alias nvc="NVIM_APPNAME=nvim-nvchad nvim"
alias lzv="NVIM_APPNAME=nvim-lazyvim nvim"
alias vml="NVIM_APPNAME=nvim-lualazy nvim"

# GNU as with intel syntax
alias asin="as -msyntax=intel -mnaked-reg"

# aliases for misc. dev tools
alias lzd="lazydocker"
alias lzg="lazygit"
# node & npm
alias nls="npm list -g --depth=0"
alias nig="npm i -g"

# dict commands
alias defc="dict -d foldoc"
alias defwn="dict -d wn"
alias defmob="dict -d moby-thesaurus"

# vcs command aliases
alias gits="git status"
alias ga="git add ."
alias gss="git log --stat --summary"
alias gl1="git log --pretty=oneline"
alias ggr="git rev-parse --show-toplevel>/dev/null 2>&1 && cd \$(git rev-parse --show-toplevel) || ( echo 'Not a git repo!'; exit 1; )"

## dev env one-liners
alias repos="find . -name .git -type d -prune -exec dirname {} \;"

# pyhton uv venv
alias ven="source .venv/bin/activate >/dev/null 2>&1 || ( echo 'Not a uv project!'; exit 1; )"

# docker command aliases
alias doci="docker image"
alias docc="docker container"
alias docv="docker volume"

# open local dev sites incognito
alias chd="google-chrome --incognito"
