# geometry_node - show node and npm/yarm version when in a node project context

(( $+commands[node] )) || return

function geometry_node {
    (( $GEOMETRY_NODE_PIN )) || [[ -f package.json ]] || [[ -f yarn.lock ]] || return

    : ${GEOMETRY_NODE_COLOR:=green} # node color
    : ${GEOMETRY_NODE_SYMBOL:="⬡"}  # node symbol
    : ${GEOMETRY_NODE_PIN:=false}   # always display?

    GEOMETRY_NODE=$(ansi $GEOMETRY_NODE_COLOR $GEOMETRY_NODE_SYMBOL)

    local package_manager=npm

    (( $+commands[yarn] )) && [[ -f yarn.lock ]] && package_manager=yarn

    local packager_version="$($package_manager --version 2>/dev/null)"
    local node_version="$(node -v 2>/dev/null)"
    echo "$GEOEMETRY_NODE $node_version ($package_manager:$packager_version)"
}
