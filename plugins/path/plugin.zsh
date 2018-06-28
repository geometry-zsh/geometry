# Color definitions
GEOMETRY_COLOR_PROMPT=${GEOMETRY_COLOR_PROMPT:-white}
GEOMETRY_COLOR_ROOT=${GEOMETRY_COLOR_ROOT:-red}
GEOMETRY_COLOR_DIR=${GEOMETRY_COLOR_DIR:-blue}
GEOMETRY_COLOR_EXIT_VALUE=${GEOMETRY_COLOR_EXIT_VALUE:-magenta}

# Symbol definitions
GEOMETRY_SYMBOL_RPROMPT=${GEOMETRY_SYMBOL_RPROMPT-"◇"}
GEOMETRY_SYMBOL_ROOT=${GEOMETRY_SYMBOL_ROOT-"▲"}
GEOMETRY_SYMBOL_PROMPT=${GEOMETRY_SYMBOL_PROMPT-"▲"}
GEOMETRY_SYMBOL_EXIT_VALUE=${GEOMETRY_SYMBOL_EXIT_VALUE-"△"}

# Misc configurations
GEOMETRY_PROMPT_PREFIX=${GEOMETRY_PROMPT_PREFIX-$'\n'}
GEOMETRY_PROMPT_PREFIX_SPACER=${GEOMETRY_PROMPT_PREFIX_SPACER-" "}

GEOMETRY_PROMPT_SUFFIX=${GEOMETRY_PROMPT_SUFFIX-""}
GEOMETRY_DIR_SPACER=${GEOMETRY_DIR_SPACER-""}
GEOMETRY_SYMBOL_SPACER=${GEOMETRY_SYMBOL_SPACER-" "}

GEOMETRY_PROMPT_PATH=${GEOMETRY_PROMPT_PATH:-"%3~"}
GEOMETRY_PROMPT_BASENAME=${GEOMETRY_PROMPT_BASENAME:-false}

PROMPT_GEOMETRY_COLORIZE_SYMBOL=${PROMPT_GEOMETRY_COLORIZE_SYMBOL:-false}
PROMPT_GEOMETRY_COLORIZE_ROOT=${PROMPT_GEOMETRY_COLORIZE_ROOT:-false}

# Helper function to colorize based off a string
prompt_geometry_hash_color() {
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

geometry_prompt_path_setup() {
  # Combine color and symbols
  GEOMETRY_EXIT_VALUE=$(prompt_geometry_colorize $GEOMETRY_COLOR_EXIT_VALUE $GEOMETRY_SYMBOL_EXIT_VALUE)
  GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)

  if $PROMPT_GEOMETRY_COLORIZE_SYMBOL; then
    GEOMETRY_COLOR_PROMPT=$(prompt_geometry_hash_color $HOST)
    GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)
  fi
}

geometry_prompt_path_check() {}

geometry_prompt_path_render() {
  local prompt_symbol=""

  if [ $? -eq 0 ] ; then
    prompt_symbol=$GEOMETRY_SYMBOL_PROMPT
  else
    prompt_symbol=$GEOMETRY_SYMBOL_EXIT_VALUE
  fi

  if $PROMPT_GEOMETRY_COLORIZE_ROOT && [[ $UID == 0 || $EUID == 0 ]]; then
    GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_ROOT $GEOMETRY_SYMBOL_ROOT)
  fi

  local dir=$GEOMETRY_PROMPT_PATH
  if $GEOMETRY_PROMPT_BASENAME; then
    dir=$(basename $PWD)
  fi

  local prompt_prefix="$GEOMETRY_PROMPT_PREFIX$GEOMETRY_PROMPT_PREFIX_SPACER"

  # Getting the correct symbol width is not as simple as getting the variable length
  # There are zero width characters that should not be accounted for.
  # E.g: characters that change the symbol to bold.
  # See https://github.com/geometry-zsh/geometry/pull/216 for context.
  # Regex used is the one in the adam2 prompt.
  #
  # TODO: We do not account for utf-8 characters which differ in the number of bytes
  # (which we calculate in the symbol_width) and in the number of columns they
  # occupy on screen. See: https://github.com/geometry-zsh/geometry/issues/3
  local symbol_width="${#${(S%%)prompt_symbol//(\%([KF1]|)\{*\}|\%[Bbkf])}}"
  local colorized_prompt_symbol="%$symbol_width{%(?.$GEOMETRY_PROMPT.$GEOMETRY_EXIT_VALUE)%}$GEOMETRY_SYMBOL_SPACER"

  local colorized_prompt_dir="%F{$GEOMETRY_COLOR_DIR}$dir%f$GEOMETRY_DIR_SPACER"

  echo "$prompt_prefix$colorized_prompt_symbol$colorized_prompt_dir$GEOMETRY_PROMPT_SUFFIX"
}
