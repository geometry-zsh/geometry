# Choose best version of grep
_geometry_set_grep() {
  (  (($+commands[rg])) && echo "rg") \
  || (($+commands[ag])) && echo "ag") \
  || echo "grep"
}

: ${GEOMETRY_GREP:=$(_geometry_set_grep)}
