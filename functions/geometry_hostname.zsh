# Hostname
#
# show user@hostname

: ${GEOMETRY_HOSTNAME_SEPARATOR:=@}

function geometry_hostname {
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && return 0
  echo -n "$USER$GEOMETRY_HOSTNAME_SEPARATOR${HOST:-$HOSTNAME}"
}
