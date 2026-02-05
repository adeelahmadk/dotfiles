## ---- setup env vars -------------------------------------
export BASH_COMPLETION_USER_DIR="$HOME/.local/share/bash-completion/completions"
export GOPATH="$HOME/.local/go"
export GOBIN="$GOPATH/bin"

## ---- Append Paths ---------------------------------------
export PATH=$PATH:/usr/local/go/bin:$GOBIN:$HOME/.cargo/bin

[ -n $(command -v source-highlight) ] && {
  # less syntax highlighting + source-highlight installation
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
  export LESS=' -R'
}
[ -n $(command -v bat) ] && {
  # manpage syntax highlighting
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c" # prevent garbled characters by disabling bold highlighting
}

## ---- initialize cli tools -------------------------------

# source scripts: activate apps, aliases, functions
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# setup bash completions
source "$BASH_COMPLETION_USER_DIR/alacritty.bash"
source "$BASH_COMPLETION_USER_DIR/git-completion.bash"
#source "$HOME/.bash-completion/git-completion.bash"

# starship prompt,zoxide smart `cd`
eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx generate-shell-completion bash)"
