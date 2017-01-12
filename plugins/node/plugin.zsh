# Color definitions
GEOMETRY_COLOR_NODE_NPM_VERISON=${GEOMETRY_COLOR_NODE_NPM_VERISON:-black}

# Symbol definitions
GEOMETRY_SYMBOL_NODE_NPM_VERISON=${GEOMETRY_SYMBOL_NODE_NPM_VERSION:-"⬡"}
GEOMETRY_NODE_NPM_VERISON=$(prompt_geometry_colorize $GEOMETRY_COLOR_NODE_NPM_VERISON GEOMETRY_SYMBOL_NODE_NPM_VERISON) 

geometry_prompt_node_setup() 

geometry_prompt_node_render(){
	local node_path="$echo "$(which node)" -v"
	local npm_path="$echo "$(which npm)" --version"
	GEOMETRY_NODE_VERSION=`(eval ${node_path})`
	GEOMETRY_NPM_VERSION=`(eval ${npm_path})`
	echo "$GEOMETRY_NODE_NPM_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NPM_VERSION)"
}

geometry_plugin_register node
