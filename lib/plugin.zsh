# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default plugins
typeset -ga GEOMETRY_PROMPT_PLUGINS
if [[ $#GEOMETRY_PROMPT_PLUGINS -eq 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS=(exec_time git hg)
fi

# List of active plugins
typeset -ga _GEOMETRY_PROMPT_PLUGINS

# List of pinned plugins
typeset -ga _GEOMETRY_PROMPT_PLUGINS_PINNED

# Set up default plugins
geometry_plugin_setup() {
  for plugin in $GEOMETRY_PROMPT_PLUGINS; do
    if [[ $plugin[1] == '+' ]]; then
      plugin=${plugin#?}
      _GEOMETRY_PROMPT_PLUGINS_PINNED+=$plugin
    fi

    source "$GEOMETRY_ROOT/plugins/$plugin/plugin.zsh"
  done
}

# Registers a plugin
geometry_plugin_register() {
  if [[ $# -eq 0 ]]; then
    echo "Error: Missing argument."
    return 1
  fi

  local plugin=$1
  # Check plugin wasn't registered before
  if [[ ! $_GEOMETRY_PROMPT_PLUGINS[(r)$plugin] == "" ]]; then
    echo "Warning: Plugin $plugin already registered."
    return 1
  fi

  # Check plugin has been sourced
  local plugin_setup_function="geometry_prompt_${plugin}_setup"
  if [[ $+functions[$plugin_setup_function] == 0 ]]; then
    echo "Error: Plugin $plugin not available."
    return 1
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
    return 1
  fi

  if [[ $+functions["geometry_prompt_${plugin}_shutdown"] != 0 ]]; then
    geometry_prompt_${plugin}_shutdown
  fi

  if [[ $_GEOMETRY_PROMPT_PLUGINS_PINNED[(r)$plugin] != "" ]]; then
    _GEOMETRY_PROMPT_PLUGINS_PINNED[$_GEOMETRY_PROMPT_PLUGINS_PINNED[(i)$plugin]]=()
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

  [ $_GEOMETRY_PROMPT_PLUGINS_PINNED[(r)$plugin] ] && return 0

  (( $+functions[geometry_prompt_${plugin}_check] )) || return 0

  geometry_prompt_${plugin}_check || return 1
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
