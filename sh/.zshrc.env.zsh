## Append paths
export PATH=$PATH:/usr/local/go/bin:$HOME/.cargo/bin

[ -d "$HOME/.local/bin" ] && export PATH=$PATH:$HOME/.local/bin

## setup env vars
export GOPATH="$HOME/.local/go"
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$GOBIN

## source scripts: activate apps, aliases, functions
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
