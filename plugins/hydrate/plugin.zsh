GEOMETRY_COLOR_HYDRATE=${GEOMETRY_COLOR_HYDRATE:-blue}
GEOMETRY_SYMBOL_HYDRATE=${GEOMETRY_SYMBOL_HYDRATE:-💧}
GEOMETRY_FILE_HYDRATE=${GEOMETRY_FILE_HYDRATE:-$TMPDIR/water}
GEOMETRY_HYDRATE_INTERVAL=${GEOMETRY_HYDRATE_INTERVAL:-20} # in minutes

geometry_prompt_hydrate_setup() {
  test -f $GEOMETRY_FILE_HYDRATE || touch $GEOMETRY_FILE_HYDRATE
}

geometry_prompt_hydrate_check() {
  test $(print $GEOMETRY_FILE_HYDRATE(.Nmm+$GEOMETRY_HYDRATE_INTERVAL))
}

geometry_prompt_hydrate_render() {
  echo $(prompt_geometry_colorize $GEOMETRY_COLOR_HYDRATE $GEOMETRY_SYMBOL_HYDRATE)
}

hydrate() {
  touch $GEOMETRY_FILE_HYDRATE
}

geometry_plugin_register hydrate
