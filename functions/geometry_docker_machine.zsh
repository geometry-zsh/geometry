# geometry_docker_machine - show the current docker machine name

function geometry_docker_machine {
  [[ -n $DOCKER_MACHINE_NAME ]] || return

  : ${GEOMETRY_DOCKER_MACHINE_COLOR:=blue}
  : ${GEOMETRY_DOCKER_MACHINE_SYMBOL:="⚓"}

  ansi $GEOMETRY_DOCKER_MACHINE_COLOR "(${GEOMETRY_DOCKER_MACHINE_SYMBOL} ${DOCKER_MACHINE_NAME})"
}
