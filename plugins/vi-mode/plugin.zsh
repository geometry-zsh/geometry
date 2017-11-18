
# For some reason this line doesn't work inside a function, otherwise
# it should be located in the _setup function.
zle -N zle-keymap-select geometry_prompt_vi-mode_render
geometry_prompt_vi-mode_setup() {}

geometry_prompt_vi-mode_check() {}

geometry_prompt_vi-mode_render() {
  # Removes previously state
  RPROMPT=${${RPROMPT/\[INSERT\] /}/\[NORMAL\] /}
  # swaps main/INSERT, vicmd/NORMAL
  local KEY=${${KEYMAP/main/INSERT}/vicmd/NORMAL}
  # Formats RPROMPT with mode + rest of prompt
  RPROMPT="[$KEY] $RPROMPT"
  # Resets prompt
  zle && zle reset-prompt
}
