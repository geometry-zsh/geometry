# time - library to convert timestamps to human readable stuff

: ${GEOMETRY_COLOR_TIME_SHORT:=green}
: ${GEOMETRY_COLOR_TIME_NEUTRAL:=white}
: ${GEOMETRY_COLOR_TIME_LONG:=red}
: ${GEOMETRY_COLOR_NO_TIME:=red}

# Format time in short format: 4s, 4h, 1d
_geometry_time_short_format() {
  local days=$1 hours=$2 minutes=$3 seconds=$4

  (( days > 0 )) && ansi $GEOMETRY_COLOR_TIME_LONG "${days}d" && return
  (( hours > 0 )) && ansi $GEOMETRY_COLOR_TIME_NEUTRAL "${hours}h" && return
  (( minutes > 0 )) && ansi $GEOMETRY_COLOR_TIME_SHORT "${minutes}m" && return

  ansi $GEOMETRY_COLOR_TIME_SHORT "${seconds}s"
}

# Format time in long format: 1d4h33m51s, 33m51s
_geometry_time_long_format() {
  local days=$1 hours=$2 minutes=$3 seconds=$4
  local human="" color=""

  (( days > 0 ))    && human+="${days}d "    && color=$GEOMETRY_COLOR_TIME_LONG
  (( hours > 0 ))   && human+="${hours}h "   && : ${color:=$GEOMETRY_COLOR_TIME_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m "

  ansi ${color:=$GEOMETRY_COLOR_TIME_SHORT} "$human ${seconds}s"
}

# from https://github.com/sindresorhus/pretty-time-zsh
_geometry_seconds_to_human_time() {
  local total_seconds=$1
  local long_format=${2:-false}

  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  $long_format && _geometry_time_long_format $days $hours $minutes $seconds
  $long_format || _geometry_time_short_format $days $hours $minutes $seconds
}
