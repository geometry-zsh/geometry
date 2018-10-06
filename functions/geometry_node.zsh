# Node
#
# Display node and npm/yarm version when in a node project context

: ${GEOMETRY_NODE_COLOR:=green} # node color
: ${GEOMETRY_NODE_SYMBOL:="⬡"}  # node symbol
: ${GEOMETRY_NODE_PIN:=false}   # always display?

(( $+commands[node] )) || (( $+commands[yarn] )) || return

GEOMETRY_NODE=$(color $GEOMETRY_NODE_COLOR $GEOMETRY_NODE_SYMBOL)

function geometry_node {
    test $GEOMETRY_NODE_PIN || test -f package.json || test -f yarn.lock || return

    local package_manager=npm

    if [[ $+commands[yarn] && -f yarn.lock ]]; then
        package_manager=yarn
    fi

    local packager_version="$($package_manager --version 2>/dev/null)"
    local node_version="$(node -v 2>/dev/null)"
    echo -n "$GEOEMETRY_NODE $node_version ($package_manager:$packager_version)"
}
