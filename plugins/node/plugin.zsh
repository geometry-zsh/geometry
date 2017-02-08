# Color definitions
GEOMETRY_COLOR_NODE_NPM_VERSION=${GEOMETRY_COLOR_NODE_NPM_VERSION:-black}

# Symbol definitions
GEOMETRY_SYMBOL_NODE_NPM_VERSION=${GEOMETRY_SYMBOL_NODE_NPM_VERSION:-"⬡"}
GEOMETRY_NODE_NPM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_NODE_NPM_VERSION $GEOMETRY_SYMBOL_NODE_NPM_VERSION) 


geometry_prompt_node_setup(){} 

geometry_prompt_node_render(){
    local -a files
    files=($(ls -a ${PWD} | egrep -e ".nvmrc|yarn.lock"))

    if [[ -n $files[1] ]]; then
        case "$files[1]" in 
            ".nvmrc")
                local NODE_VERSION=$(nvm version "$(cat $files[1])")
                if [[ "$NODE_VERSION" != "N/A" ]]; then
                    nvm use 2> /dev/null
                elif [[ "$NODE_VERSION" == "N/A" ]]; then
                    echo "Need to install this version $NODE_VERSION of node.Using default version of node."
                    nvm use default 2> /dev/null                
                fi
                ;;
            "yarn.lock")
                ;;
        esac    
        if (( $+commands[node] != 0 )); then
            GEOMETRY_NODE_VERSION="$(node -v 2> /dev/null)"
            GEOMETRY_NPM_VERSION="$(npm --version 2> /dev/null)" 
            echo "$GEOMETRY_NODE_NPM_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NPM_VERSION)"
        fi

    fi
}

geometry_plugin_register node

