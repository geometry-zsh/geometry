zle -N zle-keymap-select geometry_prompt_vi-mode_render

geometry_prompt_vi-mode_setup() {}
geometry_prompt_vi-mode_check() {}
geometry_prompt_vi-mode_render() {
    RPROMPT=${${RPROMPT/\[INSERT\] /}/\[NORMAL\] /}
    local KEY=${${KEYMAP/main/INSERT}/vicmd/NORMAL}
    RPROMPT="[$KEY] $RPROMPT"
    zle && zle reset-prompt || echo -n $RPROMPT
}
