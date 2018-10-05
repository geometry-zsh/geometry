# Status
#
# Display a symbol with error/success and root/non-root information

: ${GEOMETRY_STATUS_COLOR_OK:=white}      # Color when everything is ok
: ${GEOMETRY_STATUS_COLOR_ERROR:=magenta} # Color if there was an error
: ${GEOMETRY_STATUS_COLOR_HASH:=false}    # Color indicates hostname

: ${GEOMETRY_STATUS_SYMBOL_OK:=▲}         # Default symbol
: ${GEOMETRY_STATUS_SYMBOL_ERROR:=△}      # Error symbol
: ${GEOMETRY_SYMBOL_STATUS_ROOT_OK:=▲}    # Root symbol
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
GEOMETRY_STATUS_OK=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_OK $GEOMETRY_STATUS_SYMBOL_OK)
GEOMETRY_STATUS_ERROR=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ERROR)
GEOMETRY_STATUS_ROOT_OK=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_OK $GEOMETRY_STATUS_SYMBOL_ROOT_OK)
GEOMETRY_STATUS_ROOT_ERROR=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ROOT_ERROR)

if $GEOMETRY_STATUS_SYMBOL_COLOR_HASH; then
  GEOMETRY_STATUS_COLOR_OK=$(_geometry_hash_color $HOST)
  GEOMETRY_STATUS_OK=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_OK $GEOMETRY_STATUS_SYMBOL_OK)
fi


function geometry_status() {
  local _status=$GEOMETRY_STATUS_OK

  if (( $+GEOMETRY_LAST_ERROR )); then
    if [[ $UID == 0 || $EUID == 0 ]]; then
        _status=$GEOMETRY_STATUS_ROOT_OK
    fi
  else
    _status=$GEOMETRY_STATUS_ERROR
    if [[ $UID == 0 || $EUID == 0 ]]; then
        _status=$GEOMETRY_STATUS_ROOT_ERROR
    fi
  fi

  echo -n "%{%(?.$_status.$GEOMETRY_STATUS_ERROR)%}"
}
