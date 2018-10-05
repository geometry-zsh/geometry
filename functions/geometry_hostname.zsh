# Hostname
#
# show user@hostname

: ${GEOMETRY_HOSTNAME_SEPARATOR:=@}       # separator between user and hostname
: ${GEOMETRY_HOSTNAME_HIDE_ON:=localhost} # hide plugin on this host

function geometry_hostname {
  local _host=${HOST:-$HOSTNAME}
  [[ "$_host" = "$GEOMETRY_HOSTNAME_HIDE_ON" ]] && return 0
  echo -n "${USER}${GEOMETRY_HOSTNAME_SEPARATOR}${_host}"
}
