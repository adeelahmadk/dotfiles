# Append paths
export PATH=$PATH:/usr/local/go/bin

# Set env vars
export BASH_COMPLETION_USER_DIR="$HOME/.local/share/bash-completion/completions"
export GOPATH="$HOME/.local/go"
export GOBIN="$GOPATH/bin"
export PATH=$PATH:$GOBIN

## source scripts: activate apps, aliases, functions

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init bash)"
eval "$(zoxide init bash)"

source "$BASH_COMPLETION_USER_DIR/alacritty.bash"
source "$BASH_COMPLETION_USER_DIR/git-completion.bash"
#source "$HOME/.bash-completion/git-completion.bash"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx generate-shell-completion bash)"
