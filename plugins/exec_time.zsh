zmodload zsh/datetime || return

# Flags
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}
PROMPT_GEOMETRY_EXEC_TIME=${PROMPT_GEOMETRY_EXEC_TIME:-false}

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
  if $PROMPT_GEOMETRY_EXEC_TIME; then
    add-zsh-hook precmd prompt_geometry_clear_timestamp
    add-zsh-hook precmd prompt_geometry_check_command_exec_time
    add-zsh-hook precmd prompt_geometry_set_command_timestamp
  fi

  return $PROMPT_GEOMETRY_EXEC_TIME
}

geometry_prompt_exec_time_render() {
  echo "$prompt_geometry_command_exec_time"
}
