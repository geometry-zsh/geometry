# A geometry plugin to display the ZLE vi-mode state.

update_rprompt() {
    RPROMPT=${${RPROMPT/\[NORMAL\]/}/\[INSERT\]/}
    RPROMPT="[$1]$RPROMPT"
}

update_prompt() {
    PROMPT=${${PROMPT/\[NORMAL\]/}/\[INSERT\]/}
    PROMPT="[$1]$PROMPT"
}

function zle-keymap-select {
    keymap=$([[ $KEYMAP == vicmd ]] && echo "NORMAL" || echo "INSERT")
    (( ${GEOMETRY_RPROMPT[(i)geometry_vi]} <= ${#GEOMETRY_RPROMPT} )) && update_rprompt $keymap
    (( ${GEOMETRY_PROMPT[(i)geometry_vi]} <= ${#GEOMETRY_PROMPT} )) && update_prompt $keymap
    zle reset-prompt
}

zle -N zle-keymap-select

geometry_vi() {
    # Empty render function, these are handled by zle-keymap-select
}

