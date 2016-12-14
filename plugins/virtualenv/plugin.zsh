# Color definitions
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_PROMPT:-green}

geometry_prompt_virtualenv_setup() {}

geometry_prompt_virtualenv_render() {
  local ref
  if test ! -z $VIRTUAL_ENV; then
    ref=$(basename $VIRTUAL_ENV) || return
    echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV "(${ref})")"
  fi
}

# Self-register plugin
geometry_plugin_register virtualenv
