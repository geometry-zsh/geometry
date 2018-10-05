GEOMETRY_COLOR_DIR=${GEOMETRY_COLOR_DIR:-blue}
GEOMETRY_PROMPT_PATH=${GEOMETRY_PROMPT_PATH:-"%3~"}
GEOMETRY_PROMPT_BASENAME=${GEOMETRY_PROMPT_BASENAME:-false}

function geometry_path() {
  local dir=$GEOMETRY_PROMPT_PATH
  if $GEOMETRY_PROMPT_BASENAME; then
    dir=$(basename $PWD)
  fi

  echo -n $(_geometry_colorize $GEOMETRY_COLOR_DIR $dir)
}
