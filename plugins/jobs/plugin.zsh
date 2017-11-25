# Color definitions
GEOMETRY_COLOR_JOBS=${GEOMETRY_COLOR_JOBS:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_JOBS=${GEOMETRY_SYMBOL_JOBS:-"⚙"}

geometry_prompt_jobs_setup() {}

geometry_prompt_jobs_check() {
  [[ $(print -P '%j') == "0" ]]
}

geometry_prompt_jobs_render() {
  local jobs_prompt='%(1j.'$GEOMETRY_SYMBOL_JOBS' %j.)'
  echo $(prompt_geometry_colorize $GEOMETRY_COLOR_JOBS $jobs_prompt)
}
