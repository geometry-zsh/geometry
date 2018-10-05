# Path
#
# Shows the current path

: ${GEOMETRY_PATH_COLOR:=blue}          # color
: ${GEOMETRY_PATH_SYMBOL_HOME:="%3~"}   # symbol representing the home directory
: ${GEOMETRY_PATH_SHOW_BASENAME:=false} # show just the current directory

function geometry_path {
  local dir=$GEOMETRY_PATH_SYMBOL_HOME
  if $GEOMETRY_PATH_SHOW_BASENAME; then
    dir=$(basename $PWD)
  fi

  echo -n $(_geometry_colorize $GEOMETRY_PATH_COLOR $dir)
}
