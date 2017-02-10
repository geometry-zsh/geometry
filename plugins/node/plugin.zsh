# Color definitions
GEOMETRY_COLOR_PACKAGER_VERSION=${GEOMETRY_COLOR_PACKAGER_VERSION:-black}

# Symbol definitions
GEOMETRY_SYMBOL_PACKAGER_VERSION=${GEOMETRY_SYMBOL_PACKAGER_VERSION:-"⬡"}
GEOMETRY_NODE_PACKAGER_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_PACKAGER_VERSION $GEOMETRY_SYMBOL_PACKAGER_VERSION) 

geometry_prompt_node_setup() {}

geometry_prompt_node_render() {
    if [[ ! $+commands[node] ]]; then 
        return
    fi

    if [[ ! -f "$PWD/package.json" ]]; then
        return
    fi

    local GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER=npm

    if [[ $+commands[yarn] && -f "$PWD/yarn.lock" ]]; then
        GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER=yarn
    fi 

    GEOMETRY_PACKAGER_VERSION="$($GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER --version 2> /dev/null)" 
    GEOMETRY_NODE_VERSION="$(node -v 2> /dev/null)"
    echo "$GEOMETRY_NODE_PACKAGER_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER:$GEOMETRY_PACKAGER_VERSION)"
}

geometry_plugin_register node

