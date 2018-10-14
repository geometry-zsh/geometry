# geometry_docker_machine - show the current docker machine name

: ${GEOMETRY_DOCKER_MACHINE_COLOR:=blue}
: ${GEOMETRY_DOCKER_MACHINE_SYMBOL:="⚓"}

function geometry_docker_machine {
  test -n $DOCKER_MACHINE_NAME || return
  echo -n "$(color $GEOMETRY_DOCKER_MACHINE_COLOR "(${GEOMETRY_DOCKER_MACHINE_SYMBOL} ${DOCKER_MACHINE_NAME})")"
}
