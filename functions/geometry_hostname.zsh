# geometry_hostname - show user@hostname

geometry_hostname() {
  local _host=${HOST:-$HOSTNAME}
  [[ "$_host" = "${GEOMETRY_HOSTNAME_HIDE_ON:-localhost}" ]] && return
  echo -n "${USER}${GEOMETRY_HOSTNAME_SEPARATOR:-@}${_host}"
}
