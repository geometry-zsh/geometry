# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default context
typeset -ga GEOMETRY_PROMPT_CTX
if [[ $#GEOMETRY_PROMPT_CTX -eq 0 ]]; then
  GEOMETRY_PROMPT_CTX=(primary secondary)
fi

# Migrate from old config
if [[ ! $#GEOMETRY_PROMPT_PLUGINS -eq 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS_SECONDARY=${(j/ /)GEOMETRY_PLUGIN_PLUGINS}
fi

# Define default plugins
typeset -gA GEOMETRY_PROMPT_PLUGINS
GEOMETRY_PROMPT_PLUGINS[primary]='path hostname'

# Migrate from old config
if [[ $GEOMETRY_PROMPT_PLUGINS_SECONDARY == "" ]]; then
  GEOMETRY_PROMPT_PLUGINS[secondary]='exec_time jobs git hg'
else
  GEOMETRY_PROMPT_PLUGINS[secondary]=$GEOMETRY_PROMPT_PLUGINS_SECONDARY
fi

# List of active plugins
typeset -gA _GEOMETRY_PROMPT_PLUGINS

# Set up default plugins
geometry_plugin_setup() {
  for ctx in $GEOMETRY_PROMPT_CTX; do
    local _ctx_plugins=(${(s/ /)GEOMETRY_PROMPT_PLUGINS[$ctx]})
    for plugin in $_ctx_plugins; do
      test -f "$GEOMETRY_ROOT/plugins/${plugin#+}/plugin.zsh" && source $_
    done
  done
}

# Registers a plugin
geometry_plugin_register() {
  if [[ $# -eq 0 ]]; then
    >&2 echo "Error: Missing argument."
    return 1
  fi

  local plugin=$1
  # Default to secondary context for backward compatibility
  local ctx=${2:-secondary}

  # Check plugin wasn't registered before
  local _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  if [[ ! $_ctx_plugins[(r)$plugin] == "" ]]; then
    >&2 echo "Warning: '$plugin' plugin already registered on $ctx context."
    return 1
  fi

  # Check plugin has been sourced
  local plugin_setup_function="geometry_prompt_${plugin}_setup"
  if [[ $+functions[$plugin_setup_function] == 0 ]]; then
    >&2 echo "Error: '$plugin' plugin not available."
    return 1
  fi

  if geometry_prompt_${plugin}_setup $ctx; then
    _ctx_plugins+=$plugin
    _GEOMETRY_PROMPT_PLUGINS[$ctx]=${(j/ /)_ctx_plugins}
  fi
}

# Unregisters a given plugin
geometry_plugin_unregister() {
  local plugin=$1
  local ctx=${2:-secondary}

  # Check plugin is registered
  local _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  if [[ $_ctx_plugins[(r)$plugin] == "" ]]; then
    >&2 echo "Error: '$plugin' plugin not registered on $ctx context."
    return 1
  fi

  if [[ $+functions["geometry_prompt_${plugin}_shutdown"] != 0 ]]; then
    geometry_prompt_${plugin}_shutdown $ctx
  fi

  _ctx_plugins[$_ctx_plugins[(i)$plugin]]=()
  _GEOMETRY_PROMPT_PLUGINS[$ctx]=${(j/ /)_ctx_plugins}
}

# List registered plugins
geometry_plugin_list() {
  for ctx in $GEOMETRY_PROMPT_CTX; do
    echo "$ctx:"
    echo $_GEOMETRY_PROMPT_PLUGINS[$ctx]
  done
}

# Checks a registered plugin
geometry_plugin_check() {
  local plugin=$1
  local ctx=${2:-secondary}

  local _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  [ $_ctx_plugins[(r)+$plugin] ] && return 0

  (( $+functions[geometry_prompt_${plugin}_check] )) || return 0

  geometry_prompt_${plugin}_check $ctx || return 1
}

# Renders the registered plugins
geometry_plugin_render() {
  local rprompt=""
  local render=""
  local ctx=${1:-secondary}

  local _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  for plugin in $_ctx_plugins; do
    geometry_plugin_check $plugin $ctx || continue

    render=$(geometry_prompt_${plugin}_render $ctx)
    if [[ -n $render ]]; then
      [[ -n $rprompt ]] && rprompt+="$GEOMETRY_PLUGIN_SEPARATOR"
      rprompt+="$render"
    fi
  done

  echo "$rprompt"
}
