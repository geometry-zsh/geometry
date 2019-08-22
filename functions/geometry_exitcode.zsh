# geometry_status - show a symbol with error/success and root/non-root information

geometry_exitcode() {
  : ${GEOMETRY_EXITCODE_COLOR:=red} 
    (( $GEOMETRY_LAST_STATUS )) && ansi $GEOMETRY_EXITCODE_COLOR $GEOMETRY_LAST_STATUS
}
