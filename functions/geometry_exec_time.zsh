# Exec time
#
# Show the elapsed time for long running commands
#
# See ![long_running](../screenshots/long_running.png) for an example

: ${GEOMETRY_EXEC_TIME_PATIENCE:=5} # How many seconds to wait before showing

zmodload zsh/datetime || return # required for `$EPOCHSECONDS`

typeset -g _geometry_command_timestamp
typeset -g _geometry_command_exec_time

# Stores (into _geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
_geometry_check_command_exec_time() {
  integer elapsed
  # Default value for exec_time is an empty string (ie, it won't be rendered),
  # if we don't clear this up it may be rendered each time
  _geometry_command_exec_time=

  # Check if elapsed time is above the configured threshold
  (( elapsed = EPOCHSECONDS - ${_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $GEOMETRY_EXEC_TIME_PATIENCE )); then
    _geometry_command_exec_time="$(_geometry_seconds_to_human_time $elapsed)"
  fi

  # Clear timestamp after we're done calculating exec_time
  _geometry_command_timestamp=
}

_geometry_set_command_timestamp() {
  _geometry_command_timestamp=$EPOCHSECONDS
}

# Begin to track the EPOCHSECONDS since this command is executed
add-zsh-hook preexec _geometry_set_command_timestamp
# Check if we need to display execution time
add-zsh-hook precmd _geometry_check_command_exec_time

geometry_exec_time() {
  echo -n "$_geometry_command_exec_time"
}
