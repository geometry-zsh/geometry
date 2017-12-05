# Load zsh/datetime module to be able to access `$EPOCHSECONDS`
zmodload zsh/datetime || return

# Flags
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}
GEOMETRY_COLOR_TIME_SHORT=${GEOMETRY_COLOR_TIME_SHORT:-green}
GEOMETRY_COLOR_TIME_NEUTRAL=${GEOMETRY_COLOR_TIME_NEUTRAL:-white}
GEOMETRY_COLOR_TIME_LONG=${GEOMETRY_COLOR_TIME_LONG:-red}
GEOMETRY_COLOR_NO_TIME=${GEOMETRY_COLOR_NO_TIME:-red}

typeset -g geometry_time_human
typeset -g geometry_time_color

# Format time in short format: 4s, 4h, 1d
-prompt_geometry_time_short_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

  if (( days > 0 )); then
    human="${days}d"
    color=$GEOMETRY_COLOR_TIME_LONG
  elif (( hours > 0 )); then
    human="${hours}h"
    color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
  elif (( minutes > 0 )); then
    human="${minutes}m"
    color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
  else
    human="${seconds}s"
    color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
  fi

  geometry_time_color=$color
  geometry_time_human=$human
}

# Format time in long format: 1d4h33m51s, 33m51s
-prompt_geometry_time_long_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

  (( days > 0 )) && human+="${days}d " && color=$GEOMETRY_COLOR_TIME_LONG
  (( hours > 0 )) && human+="${hours}h " && color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m "
  human+="${seconds}s" && color=${color:-$GEOMETRY_COLOR_TIME_SHORT}

  geometry_time_color=$color
  geometry_time_human=$human
}

# from https://github.com/sindresorhus/pretty-time-zsh
prompt_geometry_seconds_to_human_time() {
  local total_seconds=$1
  local long_format=$2

  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  # It looks redundant but it seems it's not
  if [[ $long_format == true ]]; then
    -prompt_geometry_time_long_format $days $hours $minutes $seconds
  else
    -prompt_geometry_time_short_format $days $hours $minutes $seconds
  fi

  echo "$(prompt_geometry_colorize $geometry_time_color $geometry_time_human)"
}

typeset -g prompt_geometry_command_timestamp
typeset -g prompt_geometry_command_exec_time

# Stores (into prompt_geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_geometry_check_command_exec_time() {
  integer elapsed
  # Default value for exec_time is an empty string (ie, it won't be rendered),
  # if we don't clear this up it may be rendered each time
  prompt_geometry_command_exec_time=

  # Check if elapsed time is above the configured threshold
  (( elapsed = EPOCHSECONDS - ${prompt_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME )); then
    prompt_geometry_command_exec_time="$(prompt_geometry_seconds_to_human_time $elapsed)"
  fi

  # Clear timestamp after we're done calculating exec_time
  prompt_geometry_command_timestamp=
}

prompt_geometry_set_command_timestamp() {
  prompt_geometry_command_timestamp=$EPOCHSECONDS
}

geometry_prompt_exec_time_setup() {
  # Begin to track the EPOCHSECONDS since this command is executed
  add-zsh-hook preexec prompt_geometry_set_command_timestamp
  # Check if we need to display execution time
  add-zsh-hook precmd prompt_geometry_check_command_exec_time

  return true
}

geometry_prompt_exec_time_check() {}

geometry_prompt_exec_time_render() {
  echo "$prompt_geometry_command_exec_time"
}
