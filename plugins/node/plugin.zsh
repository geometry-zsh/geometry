# Color definitions
GEOMETRY_COLOR_PACKAGER_VERSION=${GEOMETRY_COLOR_PACKAGER_VERSION:-green}

# Symbol definitions
GEOMETRY_SYMBOL_PACKAGER_VERSION=${GEOMETRY_SYMBOL_PACKAGER_VERSION:-"⬡"}
GEOMETRY_NODE_PACKAGER_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_PACKAGER_VERSION $GEOMETRY_SYMBOL_PACKAGER_VERSION) 

geometry_prompt_node_setup() {
    (( $+commands[node] )) || (( $+commands[yarn] )) || return 1
}

geometry_prompt_node_check() {
    test -f package.json || test -f yarn.lock || return 1
}

geometry_prompt_node_render() {
    local GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER=npm

    if [[ $+commands[yarn] && -f yarn.lock ]]; then
        GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER=yarn
    fi

    GEOMETRY_PACKAGER_VERSION="$($GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER --version 2> /dev/null)" 
    GEOMETRY_NODE_VERSION="$(node -v 2> /dev/null)"
    echo "$GEOMETRY_NODE_PACKAGER_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NODE_DEFAULT_PACKAGE_MANAGER:$GEOMETRY_PACKAGER_VERSION)"
}
