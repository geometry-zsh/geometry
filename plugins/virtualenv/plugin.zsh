# Color definitions
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_PROMPT:-green}

geometry_prompt_virtualenv_setup() {}

geometry_prompt_virtualenv_check() {
  test $VIRTUAL_ENV || return 1
}

geometry_prompt_virtualenv_render() {
  local ref=$(basename $VIRTUAL_ENV)
  echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV "(${ref})")"
}

# Self-register plugin
geometry_plugin_register virtualenv
