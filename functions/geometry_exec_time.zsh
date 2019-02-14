# geometry_exec_time - show the elapsed time for long running commands
#
# See ![long_running](../screenshots/long_running.png) for an example

autoload -U add-zsh-hook
zmodload zsh/datetime zsh/stat

: ${GEOMETRY_EXEC_TIME_FILE:=${TMPDIR:=/tmp}/geometry_exec_time}
: ${GEOMETRY_EXEC_TIME_PATIENCE:=5} # seconds before showing

# Begin to track the EPOCHSECONDS since this command is executed
geometry::time_command_begin() { touch $GEOMETRY_EXEC_TIME_FILE }
add-zsh-hook preexec geometry::time_command_begin

geometry_exec_time() {
  [[ -z "$GEOMETRY_EXEC_TIME_FILE" ]] && return
  [[ -f "$GEOMETRY_EXEC_TIME_FILE" ]] || return
  local atime=$(zstat +atime $GEOMETRY_EXEC_TIME_FILE)
  (( elapsed = $EPOCHSECONDS - $atime ))
  (( elapsed > $GEOMETRY_EXEC_TIME_PATIENCE )) && geometry::time $elapsed
  rm $GEOMETRY_EXEC_TIME_FILE 2>/dev/null
}
