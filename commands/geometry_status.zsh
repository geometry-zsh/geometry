# Color definitions
GEOMETRY_STATUS_COLOR_OK=${GEOMETRY_STATUS_COLOR_OK:-white}
GEOMETRY_STATUS_COLOR_ERROR=${GEOMETRY_STATUS_COLOR_ERROR:-magenta}
GEOMETRY_STATUS_SYMBOL_COLOR_HASH=${GEOMETRY_STATUS_SYMBOL_COLOR_HASH:-false}

# Symbol definitions
GEOMETRY_STATUS_SYMBOL_OK=${GEOMETRY_SYMBOL_STATUS_OK:-"▲"}
GEOMETRY_STATUS_SYMBOL_ERROR=${GEOMETRY_STATUS_SYMBOL_ERROR:-"△"}
GEOMETRY_STATUS_SYMBOL_ROOT_OK=${GEOMETRY_SYMBOL_STATUS_ROOT:-"▲"}
GEOMETRY_STATUS_SYMBOL_ROOT_ERROR=${GEOMETRY_SYMBOL_STATUS_ERROR:-"△"}

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
  GEOMETRY_STATUS_COLOR_OK=$(prompt_geometry_hash_color $HOST)
  GEOMETRY_STATUS_OK=$(_geometry_colorize $GEOMETRY_STATUS_COLOR_OK $GEOMETRY_STATUS_SYMBOL_OK)
fi


function geometry_status() {
  local _status=$GEOMETRY_STATUS_OK

  if [[ $GEOMETRY_LAST_ERROR == '0' ]]; then
    if [[ $UID == 0 || $EUID == 0 ]]; then
        _status=$GEOMETRY_STATUS_ROOT_OK
    fi
  else
    _status=$GEOMETRY_STATUS_ERROR
    if [[ $UID == 0 || $EUID == 0 ]]; then
        _status=$GEOMETRY_STATUS_ROOT_ERROR
    fi
  fi

  # Getting the correct symbol width is not as simple as getting the variable length
  # There are zero width characters that should not be accounted for.
  # E.g: characters that change the symbol to bold.
  # See https://github.com/geometry-zsh/geometry/pull/216 for context.
  # Regex used is the one in the adam2 prompt.
  #
  # TODO: We do not account for utf-8 characters which differ in the number of bytes
  # (which we calculate in the symbol_width) and in the number of columns they
  # occupy on screen. See: https://github.com/geometry-zsh/geometry/issues/3
  local symbol_width="${#${(S%%)_symbol//(\%([KF1]|)\{*\}|\%[Bbkf])}}"

  echo -n "%$symbol_width{%(?.$_status.$GEOMETRY_EXIT_VALUE)%}"
}
