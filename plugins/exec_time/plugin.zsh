# Load zsh/datetime module to be able to access `$EPOCHSECONDS`
zmodload zsh/datetime || return

# Flags
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}

typeset -g prompt_geometry_command_timestamp
typeset -g prompt_geometry_command_exec_time

# stores (into prompt_geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_geometry_check_command_exec_time() {
  integer elapsed
  (( elapsed = EPOCHSECONDS - ${prompt_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME )); then
    prompt_geometry_command_exec_time="$(prompt_geometry_seconds_to_human_time $elapsed)"
  fi
}

prompt_geometry_set_command_timestamp() {
  prompt_geometry_command_timestamp=$EPOCHSECONDS
}

prompt_geometry_clear_timestamp() {
  unset prompt_geometry_command_exec_time
}

geometry_prompt_exec_time_setup() {
  add-zsh-hook precmd prompt_geometry_clear_timestamp
  add-zsh-hook precmd prompt_geometry_check_command_exec_time
  add-zsh-hook precmd prompt_geometry_set_command_timestamp

  return true
}

check_empty_buffer() {
  if [[ $#BUFFER == 0 ]]; then
    current_command_is_empty=true
  else
    current_command_is_empty=false
  fi
}

zle -N zle-line-finish check_empty_buffer

geometry_prompt_exec_time_render() {
  if [ "$current_command_is_empty" = false ]; then
    echo "$prompt_geometry_command_exec_time"
  fi
}

# Self-register plugin
geometry_plugin_register exec_time
