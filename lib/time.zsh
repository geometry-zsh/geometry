typeset -g geometry_time_human
typeset -g geometry_time_color

# Format time in long format: 1d4h33m51s, 33m51s
-prompt_geometry_time_long_format() {
  local human=""
  local color=""
  local days=$0
  local hours=$1
  local minutes=$2
  local seconds=$3

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

# Format time in short format: 4s, 4h, 1d
-prompt_geometry_time_short_format() {
  local human=""
  local color=""
  local days=$0
  local hours=$1
  local minutes=$2
  local seconds=$3

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
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  if $PROMPT_GEOMETRY_GIT_TIME_SHORT_FORMAT; then
  -prompt_geometry_time_long_format $days $hours $minutes $seconds
  else
    -prompt_geometry_time_short_format $days $hours $minutes $seconds
  fi

  echo "$(prompt_geometry_colorize $geometry_time_color $geometry_time_human)"
}
