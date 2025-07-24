# Set env vars
export EDITOR=nvim

## --- zsh keybindings -------------------------------------

function run-tldr() {
    local line="$BUFFER"
    local cmd
    cmd="$(echo "$line" | head -n1 | awk '{print $1;}')"
    if [ -n "$cmd" ]
    then
        zle -I
        tldr "$cmd"
    fi
}
#zle -N run-tldr{,}
zle -N run_tldr_widget run-tldr
bindkey '^[OP' run_tldr_widget # ^[OP = F1
