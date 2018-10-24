# geometry_path - show the current path

geometry_path() {
  : ${GEOMETRY_PATH_COLOR:=blue}          # color
  : ${GEOMETRY_PATH_SYMBOL_HOME:="%3~"}   # symbol representing the home directory
  : ${GEOMETRY_PATH_SHOW_BASENAME:=false} # show just the current directory

  local dir=$GEOMETRY_PATH_SYMBOL_HOME
  (( $GEOMETRY_PATH_SHOW_BASENAME )) && dir=${PWD:t}
  ansi $GEOMETRY_PATH_COLOR $dir
}
