# Color definitions
GEOMETRY_COLOR_NODE_NPM_VERSION=${GEOMETRY_COLOR_NODE_NPM_VERSION:-black}

# Symbol definitions
GEOMETRY_SYMBOL_NODE_NPM_VERSION=${GEOMETRY_SYMBOL_NODE_NPM_VERSION:-"⬡"}
GEOMETRY_NODE_NPM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_NODE_NPM_VERSION $GEOMETRY_SYMBOL_NODE_NPM_VERSION) 


geometry_prompt_node_setup(){} 

geometry_prompt_node_render(){
    if (( $+commands ['node'] == 0 )); then
        echo ""
    else
        GEOMETRY_NODE_VERSION="$(node -v)"
        GEOMETRY_NPM_VERSION="$(npm --version)" 
        echo "$GEOMETRY_NODE_NPM_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NPM_VERSION)"
    fi
}

geometry_plugin_register node
