# geometry_exitcode - show the exit code of the last status

geometry_exitcode() {
  (( $GEOMETRY[LAST_STATUS] )) && ansi ${GEOMETRY_EXITCODE_COLOR:-red} $GEOMETRY[LAST_STATUS] || echo ''
}
