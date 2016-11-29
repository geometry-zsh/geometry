# from https://github.com/sindresorhus/pretty-time-zsh
prompt_geometry_seconds_to_human_time() {
  local color=""
  local human="" total_seconds=$1
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  if $PROMPT_GEOMETRY_GIT_TIME_SHORT_FORMAT; then
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
  else
    (( days > 0 )) && human+="${days}d " && color=$GEOMETRY_COLOR_TIME_LONG
    (( hours > 0 )) && human+="${hours}h " && color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
    (( minutes > 0 )) && human+="${minutes}m "
    human+="${seconds}s" && color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
  fi

  echo "$(prompt_geometry_colorize $color $human)"
}
