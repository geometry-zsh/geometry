GEOMETRY_PLUGIN_HOSTNAME_PREFIX=${GEOMETRY_PLUGIN_HOSTNAME_PREFIX:-"@"}

function mnml_hostname {
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]] && return 0
  echo -n "${USER}$GEOMETRY_PLUGIN_HOSTNAME_PREFIX$(hostname)"
}