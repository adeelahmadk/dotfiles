### ---- PATH init ------------------------------------------
export PATH=$HOME/bin:$PATH

### ---- ZSH HOME -------------------------------------------
if [[ ! -d "$HOME/.config/zsh" ]]; then
    mkdir -p "$HOME/.config/zsh"
fi
export ZSH=$HOME/.config/zsh

### ---- history config -------------------------------------
export HISTFILE=$ZSH/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# History won't show duplicates on search.
setopt HIST_FIND_NO_DUPS

### --- configure completion ---------------------------------

zstyle ':completion:*' menu yes select

### ---- init plugins ----------------------------------------

source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

fpath=($ZSH/plugins/zsh-completions/src $fpath)

### ---- source dotfiles -------------------------------------
if [[ -f "$ZSH/.zshrc_env" ]]; then
    . "$ZSH/.zshrc_env"
fi

if [[ -f "$ZSH/.zshrc_aliases" ]]; then
    . "$ZSH/.zshrc_aliases"
fi

if [[ -f "$ZSH/.zshrc_funcs" ]]; then
    . "$ZSH/.zshrc_funcs"
fi

