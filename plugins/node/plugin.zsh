#Symbol definitions
GEOMETRY_VERSION_SYMBOL=${GEOMETRY_VERSION_SYMBOL:-"o"}

geometry_prompt_node_setup() {}

geometry_prompt_node_render(){
	local node_path="$echo "$(which node)" -v"
	local npm_path="$echo "$(which npm)" --version"
	GEOMETRY_NODE_VERSION=`(eval ${node_path})`
	GEOMETRY_NPM_VERSION=`(eval ${npm_path})`
	echo "$GEOMETRY_VERSION_SYMBOL $GEOMETRY_NODE_VERSION ($GEOMETRY_NPM_VERSION)"
}

geometry_plugin_register node
