# mnml_path - show the current path

mnml_path() {
  local dir=${MNML_PATH_SYMBOL_HOME:="%3~"}   # symbol representing the home directory
  ( ${MNML_PATH_SHOW_BASENAME:=false} ) && dir=${PWD:t}
  ansi ${MNML_PATH_COLOR:=blue} $dir
}
