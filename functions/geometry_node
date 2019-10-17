# geometry_node - show node and npm/yarm version when in a node project context

geometry_node() {
    (( $+commands[node] )) || return

    test -n "$GEOMETRY_NODE_PIN" || test -f package.json || test -f yarn.lock || return 1

    GEOMETRY_NODE=$(ansi ${GEOMETRY_NODE_COLOR:=green} ${GEOMETRY_NODE_SYMBOL="⬡"})

    local package_manager=npm

    (( $+commands[yarn] )) && [[ -f yarn.lock ]] && package_manager=yarn

    local packager_version="$($package_manager --version 2>/dev/null)"
    local node_version="$(node -v 2>/dev/null)"
    echo -n "$GEOMETRY_NODE $node_version ($package_manager:$packager_version)"
}
