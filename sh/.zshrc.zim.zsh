### ---- PATH init ------------------------------------------
export PATH=$HOME/bin:$PATH
export EDITOR="nvim"

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

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${ZSH}}/zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

### Start user customization: [[

# Initialize zsh-defer.
source ${ZIM_HOME}/modules/zsh-defer/zsh-defer.plugin.zsh

### ]] End user customization

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

### Start user customization: [[

# Initialize modules.
zsh-defer source ${ZIM_HOME}/init.zsh

### ]] End user customization

# ------------------------------
# Post-init module configuration
# ------------------------------

### Start user customization: [[

#
# deferred execution
#

zsh-defer _evalcache fnm env --use-on-cd
#zsh-defer _evalcache pyenv init -
#zsh-defer _evalcache rbenv init -
zsh-defer _evalcache zoxide init zsh

#
# Initialize modules.
#

# don't defer loading the following plugins
skip_defer=(environment utility zsh-vim-mode)

for zline in ${(f)"$(<$ZIM_HOME/init.zsh)"}; do
  if [[ $zline == source* ]]; then
    skip_source=0
    for skip in "${skip_defer[@]}"; do
      if [[ $zline == *"/modules/$skip/"* ]]; then
        skip_source=1
        break
      fi
    done
    if [[ $skip_source -eq 0 ]]; then
      zsh-defer -c "${zline}"
    else
      eval "${zline}"
    fi
  else
    eval "${zline}"
  fi
done

### ]] End user customization

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# }}} End configuration added by Zim install

### --- configure completion ---------------------------------

#zstyle ':completion:*' menu yes select

### ---- init plugins ----------------------------------------
#source $ZSH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

#source $ZSH/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#fpath=($ZSH/plugins/zsh-completions/src $fpath)

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
