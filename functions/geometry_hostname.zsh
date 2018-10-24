# geometry_hostname - show user@hostname

geometry_hostname() {
  : ${GEOMETRY_HOSTNAME_SEPARATOR:=@}       # separator between user and hostname
  : ${GEOMETRY_HOSTNAME_HIDE_ON:=localhost} # hide plugin on this hostname

  local _host=${HOST:-$HOSTNAME}
  [[ "$_host" = "$GEOMETRY_HOSTNAME_HIDE_ON" ]] && return
  echo "${USER}${GEOMETRY_HOSTNAME_SEPARATOR}${_host}"
}
