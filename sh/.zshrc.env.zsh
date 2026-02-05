## ---- Append Paths ---------------------------------------

path+=(/usr/local/go/bin $HOME/.cargo/bin)

[ -d "$HOME/bin" ] && path+=($HOME/bin)
[ -d "$HOME/.local/bin" ] && path+=($HOME/.local/bin)

## ---- setup env vars -------------------------------------
export GOPATH="$HOME/.local/go"
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$GOBIN
export VENV="$HOME/.local/share/venvs"
export LIBVIRT_DEFAULT_URI='qemu:///system'

[ -n $(command -v source-highlight) ] && {
  # less syntax highlighting + source-highlight installation
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
  export LESS=' -R'
}
[ -n $(command -v bat) ] && { export MANPAGER="sh -c 'col -bx | bat -l man -p'"; export MANROFFOPT="-c"; }

## ---- initialize cli tools -------------------------------

# source scripts: activate apps, aliases, functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. "$HOME/.cargo/env"

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# starship prompt,zoxide smart `cd`
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(uv --generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
