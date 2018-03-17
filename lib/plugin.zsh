# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default context
typeset -ga GEOMETRY_PROMPT_CTX
if [[ $#GEOMETRY_PROMPT_CTX -eq 0 ]]; then
  GEOMETRY_PROMPT_CTX=(primary secondary)
fi

# Migrate from old config, previously it was only possible to
# configure the right prompt which maps to secondary ctx
if [[ ! $#GEOMETRY_PROMPT_PLUGINS -eq 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS_SECONDARY=$GEOMETRY_PROMPT_PLUGINS
fi

# Define default plugins for primary and secondary ctx
typeset -gA GEOMETRY_PROMPT_PLUGINS

# Default plugins for primary ctx
if [[ $#GEOMETRY_PROMPT_PLUGINS_PRIMARY -gt 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS[primary]=${(j/ /)GEOMETRY_PROMPT_PLUGINS_PRIMARY}
else
  GEOMETRY_PROMPT_PLUGINS[primary]='path hostname'
fi

# Default plugins for secondary ctx
if [[ $#GEOMETRY_PROMPT_PLUGINS_SECONDARY -gt 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS[secondary]=${(j/ /)GEOMETRY_PROMPT_PLUGINS_SECONDARY}
else
  GEOMETRY_PROMPT_PLUGINS[secondary]='exec_time jobs git hg'
fi

# List of active plugins
typeset -gA _GEOMETRY_PROMPT_PLUGINS

# Set up default plugins
geometry_plugin_setup() {
  local _ctx_plugins

  for ctx in $GEOMETRY_PROMPT_CTX; do
    _ctx_plugins=(${(s/ /)GEOMETRY_PROMPT_PLUGINS[$ctx]})
    for plugin in $_ctx_plugins; do
      test -f "$GEOMETRY_ROOT/plugins/${plugin#+}/plugin.zsh" \
      && source $_ \
      && geometry_plugin_register $plugin $ctx
    done
  done
}

# Registers a plugin
geometry_plugin_register() {
  if [[ $# -eq 0 ]]; then
    echo "Error: Missing argument." >&2
    return 1
  fi

  local plugin=$1
  # Default to secondary context for backward compatibility
  local ctx=${2:-secondary}

  # Override default if found in primary
  if (( ${+GEOMETRY_PROMPT_PLUGINS_PRIMARY[(r)$plugin]} )); then
    ctx=primary
  fi

  # Check plugin wasn't registered before
  local _ctx_plugins;
  _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  if [[ ! $_ctx_plugins[(r)$plugin] == "" ]]; then
    echo "Warning: '${plugin#+}' plugin already registered on $ctx context." >&2
    return 1
  fi

  # Check plugin has been sourced
  local plugin_setup_function="geometry_prompt_${plugin#+}_setup"
  if [[ $+functions[$plugin_setup_function] == 0 ]]; then
    echo "Error: '${plugin#+}' plugin not available." >&2
    return 1
  fi

  if $plugin_setup_function $ctx; then
    # Register plugin in $ctx with '+' for pinning
    _ctx_plugins+=$plugin
    _GEOMETRY_PROMPT_PLUGINS[$ctx]=${(j/ /)_ctx_plugins}
  fi
}

# Unregisters a given plugin
geometry_plugin_unregister() {
  local plugin=$1
  local ctx=${2:-secondary}

  # Check plugin is registered
  local _ctx_plugins
  _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  if [[ $_ctx_plugins[(r)$plugin] == "" ]]; then
    echo "Error: '${plugin#+}' plugin not registered on $ctx context." >&2
    return 1
  fi

  # Use shutdown function (handle pinned plugins)
  if [[ $+functions["geometry_prompt_${plugin#+}_shutdown"] != 0 ]]; then
    geometry_prompt_${plugin#+}_shutdown $ctx
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
  local plugin=${1#+}
  local ctx=${2:-secondary}
  local _ctx_plugins;

  _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  # Pinned plugins aren't checked for
  [ $_ctx_plugins[(r)+$plugin] ] && return 0

  # No need to strip-out '+' from $plugin as we have returned above
  (( $+functions[geometry_prompt_${plugin}_check] )) || return 0

  geometry_prompt_${plugin}_check $ctx || return 1
}

# Renders the registered plugins
geometry_plugin_render() {
  local ctx=${1:-secondary}
  local render=""
  local ctx_prompt=""
  local _ctx_plugins;

  _ctx_plugins=(${(s/ /)_GEOMETRY_PROMPT_PLUGINS[$ctx]})
  for plugin in $_ctx_plugins; do
    geometry_plugin_check $plugin $ctx || continue

    render=$(geometry_prompt_${plugin#+}_render $ctx)
    if [[ -n $render ]]; then
      [[ -n $ctx_prompt ]] && ctx_prompt+="$GEOMETRY_PLUGIN_SEPARATOR"
      ctx_prompt+="$render"
    fi
  done

  echo "$ctx_prompt"
}
