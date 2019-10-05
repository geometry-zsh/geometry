# geometry_exitcode - show the exit code of the last status

geometry_exitcode() {
  (( $GEOMETRY_LAST_STATUS )) && ansi ${GEOMETRY_EXITCODE_COLOR:-red} $GEOMETRY_LAST_STATUS
}
