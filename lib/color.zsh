# Define how to colorize before the variables
prompt_geometry_colorize() {
  echo "%F{$1}$2%f"
}

# alias prompt_geometry_colorize as -g-color
-g-color() {
  prompt_geometry_colorize "$@"
}
