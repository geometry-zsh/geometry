# mnml_docker_machine - show the current docker machine name

mnml_docker_machine() {
  [[ -n $DOCKER_MACHINE_NAME ]] || return

  ansi ${MNML_DOCKER_MACHINE_COLOR:=blue} "(${MNML_DOCKER_MACHINE_SYMBOL:="⚓"} ${DOCKER_MACHINE_NAME})"
}
