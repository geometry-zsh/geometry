# mnml_exec_time - show the elapsed time for long running commands

autoload -U add-zsh-hook
zmodload zsh/datetime zsh/stat

: ${MNML_EXEC_TIME_FILE:=$(mktemp)}
: ${MNML_EXEC_TIME_PATIENCE:=5} # seconds before showing

# Begin to track the EPOCHSECONDS since this command is executed
mnml::time_command_begin() { touch $MNML_EXEC_TIME_FILE; }
add-zsh-hook preexec mnml::time_command_begin

mnml_exec_time() {
  [[ -z "$MNML_EXEC_TIME_FILE" ]] && return
  [[ -f "$MNML_EXEC_TIME_FILE" ]] || return
  local atime=$(zstat +atime $MNML_EXEC_TIME_FILE)
  command rm -f $MNML_EXEC_TIME_FILE
  (( elapsed = $EPOCHSECONDS - $atime ))
  (( elapsed > $MNML_EXEC_TIME_PATIENCE )) && mnml::time $elapsed
}
