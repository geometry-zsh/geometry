# Color definitions
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_PROMPT:-green}

# Flags
PROMPT_VIRTUALENV_ENABLED=${PROMPT_VIRTUALENV_ENABLED:-false}

prompt_geometry_virtualenv() {
  if test ! -z $VIRTUAL_ENV && $PROMPT_VIRTUALENV_ENABLED; then
    ref=$(basename $VIRTUAL_ENV) || return
    echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV "(${ref})") "
  fi
}

geometry_prompt_virtualenv_setup() {

}

geometry_prompt_virtualenv_render() {
    echo $(prompt_geometry_virtualenv)
}