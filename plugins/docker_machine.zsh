# Color definitions
GEOMETRY_COLOR_DOCKER_MACHINE=${GEOMETRY_COLOR_DOCKER_MACHINE:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_DOCKER_MACHINE=${GEOMETRY_SYMBOL_DOCKER_MACHINE:-"⚓"}

# Flags
PROMPT_DOCKER_MACHINE_ENABLED=${PROMPT_DOCKER_MACHINE_ENABLED:-false}

geometry_prompt_docker_machine_setup() {
    
}

geometry_prompt_docker_machine_render() {
    if test ! -z $DOCKER_MACHINE_NAME && $PROMPT_DOCKER_MACHINE_ENABLED; then
        ref=$DOCKER_MACHINE_NAME || return
        echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_DOCKER_MACHINE "(${GEOMETRY_SYMBOL_DOCKER_MACHINE} ${ref})")"
    fi
}
