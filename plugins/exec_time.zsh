zmodload zsh/datetime || return

# Flags
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}
PROMPT_GEOMETRY_EXEC_TIME=${PROMPT_GEOMETRY_EXEC_TIME:-false}

# stores (into prompt_geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_geometry_check_command_exec_time() {
  integer elapsed
  (( elapsed = EPOCHSECONDS - ${prompt_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME )); then
    export prompt_geometry_command_exec_time="$(prompt_geometry_seconds_to_human_time $elapsed)"
  fi
}

prompt_geometry_set_command_timestamp() {
  export prompt_geometry_command_timestamp=$EPOCHSECONDS
}

prompt_geometry_clear_timestamp() {
  unset prompt_geometry_command_exec_time
}

geometry_prompt_exec_time_setup() {
  if $PROMPT_GEOMETRY_EXEC_TIME; then
    add-zsh-hook precmd prompt_geometry_clear_timestamp
    add-zsh-hook precmd prompt_geometry_check_command_exec_time

    add-zsh-hook preexec prompt_geometry_set_command_timestamp
  fi

  return $PROMPT_GEOMETRY_EXEC_TIME
}

geometry_prompt_exec_time_render() {
  # TODO if the user hits enter key and the previous command caused
  # a `prompt_geometry_command_exec_time` to be set this values will keep
  # increasing and not reset until another command is run. See `geometry_prompt_exec_time_setup`.
  echo "$prompt_geometry_command_exec_time"
}
