# geometry_path - show the current path

geometry_path() {
  local dir=${GEOMETRY_PATH_SYMBOL_HOME:-"%3~"}   # symbol representing the home directory
  ( ${GEOMETRY_PATH_SHOW_BASENAME:-false} ) && dir=${PWD:t}
  ansi ${GEOMETRY_PATH_COLOR:-blue} $dir
}
