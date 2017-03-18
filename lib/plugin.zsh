# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default plugins
typeset -ga GEOMETRY_PROMPT_PLUGINS
if [[ $#GEOMETRY_PROMPT_PLUGINS -eq 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS=(exec_time git hg)
fi

# List of active plugins
typeset -ga _GEOMETRY_PROMPT_PLUGINS

# Set up default plugins
geometry_plugin_setup() {
  for plugin in $GEOMETRY_PROMPT_PLUGINS; do
    test -f "$GEOMETRY_ROOT/plugins/${plugin#+}/plugin.zsh" && source $_
  done
}

# Registers a plugin
geometry_plugin_register() {
  if [[ $# -eq 0 ]]; then
    echo "Error: Missing argument."
    return false
  fi

  local plugin=$1
  # Check plugin wasn't registered before
  if [[ ! $_GEOMETRY_PROMPT_PLUGINS[(r)$plugin] == "" ]]; then
    echo "Warning: Plugin $plugin already registered."
    return false
  fi

  # Check plugin has been sourced
  local plugin_setup_function="geometry_prompt_${plugin}_setup"
  if [[ $+functions[$plugin_setup_function] == 0 ]]; then
    echo "Error: Plugin $plugin not available."
    return false
  fi

  if geometry_prompt_${plugin}_setup; then
    _GEOMETRY_PROMPT_PLUGINS+=$plugin
  fi
}

# Unregisters a given plugin
geometry_plugin_unregister() {
  local plugin=$1
  # Check plugin is registered
  if [[ $_GEOMETRY_PROMPT_PLUGINS[(r)$plugin] == "" ]]; then
    echo "Error: Plugin $plugin not registered."
    return false
  fi

  if [[ $+functions["geometry_prompt_${plugin}_shutdown"] != 0 ]]; then
    geometry_prompt_${plugin}_shutdown
  fi

  _GEOMETRY_PROMPT_PLUGINS[$_GEOMETRY_PROMPT_PLUGINS[(i)$plugin]]=()
}

# List registered plugins
geometry_plugin_list() {
  echo ${(j:\n:)_GEOMETRY_PROMPT_PLUGINS}
}

# Checks a registered plugin
geometry_plugin_check() {
  local plugin=$1

  [ $GEOMETRY_PROMPT_PLUGINS[(r)+$plugin] ] && return true

  (( $+functions[geometry_prompt_${plugin}_check] )) || return true

  geometry_prompt_${plugin}_check || return false
}

# Renders the registered plugins
geometry_plugin_render() {
  local rprompt=""
  local render=""

  for plugin in $_GEOMETRY_PROMPT_PLUGINS; do
    geometry_plugin_check $plugin || continue

    render=$(geometry_prompt_${plugin}_render)
    if [[ -n $render ]]; then
      [[ -n $rprompt ]] && rprompt+="$GEOMETRY_PLUGIN_SEPARATOR"
      rprompt+="$render"
    fi
  done

  echo "$rprompt"
}
