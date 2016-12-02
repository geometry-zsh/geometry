# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default plugins
typeset -ga GEOMETRY_PROMPT_DEFAULT_PROMPTS
if [[ $#GEOMETRY_PROMPT_DEFAULT_PROMPTS -eq 0 ]]; then
    GEOMETRY_PROMPT_DEFAULT_PROMPTS=(exec_time git)
fi

# List of active plugins
typeset -ga GEOMETRY_PROMPT_PLUGINS

# Set up default plugins
geometry_plugin_setup() {
  for plugin in $GEOMETRY_PROMPT_DEFAULT_PROMPTS; do
      source "$GEOMETRY_ROOT/plugins/$plugin.zsh"
  done
}

# Registers a plugin
geometry_plugin_register() {
  local plugin=$1
  if [[ $plugin == "" ]]; then
      echo "Error: Missing argument."
      return 1
  fi

  # If the plugin if OK to register
  if geometry_prompt_${plugin}_setup; then
      GEOMETRY_PROMPT_PLUGINS+=$plugin
  fi
}

# List registered plugins
geometry_plugin_list() {
    echo ${(j:\n:)GEOMETRY_PROMPT_PLUGINS}
}

# Renders the registered plugins
geometry_plugin_render() {
    local rprompt=""
    local render=""

    for plugin in $GEOMETRY_PROMPT_PLUGINS; do
        render=$(geometry_prompt_${plugin}_render)
        if [[ $render != "" ]]; then
            rprompt+="$render$GEOMETRY_PLUGIN_SEPARATOR"
        fi
    done

    echo "$rprompt"
}
