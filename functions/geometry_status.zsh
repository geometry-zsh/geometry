# geometry_status - show a symbol with error/success and root/non-root information

: ${GEOMETRY_STATUS_COLOR:=white}         # Color when everything is ok
: ${GEOMETRY_STATUS_COLOR_ERROR:=magenta} # Color if there was an error
: ${GEOMETRY_STATUS_COLOR_HASH:=false}    # Color indicates hostname

: ${GEOMETRY_STATUS_SYMBOL:=▲}            # Default symbol
: ${GEOMETRY_STATUS_SYMBOL_ERROR:=△}      # Error symbol
: ${GEOMETRY_SYMBOL_STATUS_ROOT:=▲}       # Root symbol
: ${GEOMETRY_SYMBOL_STATUS_ROOT_ERROR:=△} # Root error symbol

# Helper function to colorize based off a string
_geometry_hash_color() {
  colors=(`seq 1 9`)

  if (($(echotc Co) == 256)); then
    colors+=(`seq 17 230`)
  fi

  local sum=0
  for i in {0..${#1}}; do
    ord=$(printf '%d' "'${1[$i]}")
    sum=$(($sum + $ord))
  done

  echo ${colors[$(($sum % ${#colors}))]}
}

# Combine color and symbols
GEOMETRY_STATUS_OKAY=$(color $GEOMETRY_STATUS_COLOR $GEOMETRY_STATUS_SYMBOL)
GEOMETRY_STATUS_ERROR=$(color $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ERROR)
GEOMETRY_STATUS_ROOT_OKAY=$(color  $GEOMETRY_STATUS_COLOR $GEOMETRY_STATUS_SYMBOL_ROOT)
GEOMETRY_STATUS_ROOT_ERROR=$(color $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ROOT_ERROR)

if $GEOMETRY_STATUS_SYMBOL_COLOR_HASH; then
  GEOMETRY_STATUS_COLOR=$(_geometry_hash_color $HOST)
  GEOMETRY_STATUS_OKAY=$(color $GEOMETRY_STATUS_COLOR $GEOMETRY_STATUS_SYMBOL)
fi

function geometry_status() {
  if (( $GEOMETRY_LAST_STATUS )); then
    [[ $UID = 0 || $EUID = 0 ]] && echo -n $GEOMETRY_STATUS_ROOT_ERROR || echo -n $GEOMETRY_STATUS_ERROR
  else
    [[ $UID = 0 || $EUID = 0 ]] && echo -n $GEOMETRY_STATUS_ROOT_OKAY || echo -n $GEOMETRY_STATUS_OKAY
  fi
}
