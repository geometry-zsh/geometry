typeset -ga GEOMETRY_PROMPT_DEFAULT_PROMPTS
if [[ $#GEOMETRY_PROMPT_DEFAULT_PROMPTS -eq 0 ]]; then
    GEOMETRY_PROMPT_DEFAULT_PROMPTS=(git exec_time virtualenv docker_machine)
fi

# Set up default plugins
geometry_plugin_setup() {    
  for plugin in $GEOMETRY_PROMPT_DEFAULT_PROMPTS; do
      source "$GEOMETRY_ROOT/plugins/$plugin.zsh"
      geometry_prompt_${plugin}_setup
  done
}

# Register a plugin
geometry_plugin_register() {
    
}

geometry_plugin_render() {
    
}