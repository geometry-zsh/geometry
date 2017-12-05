GEOMETRY_PLUGIN_HOSTNAME_PREFIX=${GEOMETRY_PLUGIN_HOSTNAME_PREFIX:-"@ "}
GEOMETRY_PLUGIN_HOSTNAME_SUFFIX=${GEOMETRY_PLUGIN_HOSTNAME_SUFFIX:-""}

geometry_prompt_hostname_setup() {}

geometry_prompt_hostname_check() {
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
}

geometry_prompt_hostname_render() {
  echo "$GEOMETRY_PLUGIN_HOSTNAME_PREFIX$(hostname)$GEOMETRY_PLUGIN_HOSTNAME_SUFFIX"
}
