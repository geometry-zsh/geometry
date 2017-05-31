# Color definitions
DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}
GEOMETRY_COLOR_CONDA=${GEOMETRY_COLOR_CONDA:-$DEFAULT_COLOR}

geometry_prompt_conda_setup() {}

geometry_prompt_conda_check() {
  test $CONDA_PREFIX || return 1
}

geometry_prompt_conda_render() {
  local ref=$(basename $CONDA_PREFIX)
  echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_CONDA "(${ref})")"
}

# Self-register plugin
geometry_plugin_register conda
