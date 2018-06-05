# Color definitions
GEOMETRY_COLOR_KUBE=${GEOMETRY_COLOR_KUBE:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_KUBE=${GEOMETRY_SYMBOL_KUBE:-"⎈"}
GEOMETRY_KUBE=$(prompt_geometry_colorize $GEOMETRY_COLOR_KUBE $GEOMETRY_SYMBOL_KUBE)

prompt_geometry_get_full_kubectl_version() {
  (( $+commands[kubectl] )) && GEOMETRY_KUBECTL_VERSION_FULL="$(kubectl version --client --short)"
}

prompt_geometry_kubectl_version() {
  [[ $GEOMETRY_KUBECTL_VERSION_FULL =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_KUBECTL_VERSION=$match[1]
}

prompt_geometry_kube_config() {
  GEOMETRY_KUBECTL_CONTEXT="$(kubectl config current-context 2> /dev/null)"
  GEOMETRY_KUBECTL_NAMESPACE="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$GEOMETRY_KUBECTL_CONTEXT\")].context.namespace}" 2> /dev/null)"
}

geometry_prompt_kube_setup() {
    (( $+commands[kubectl] )) || return 1
}

geometry_prompt_kube_check() {
    (( $+commands[kubectl] )) && test -f ~/.kube/config || return 1
}

geometry_prompt_kube_render() {
    prompt_geometry_get_full_kubectl_version
    prompt_geometry_kubectl_version
    prompt_geometry_kube_config

    if [[ -z $GEOMETRY_KUBECTL_NAMESPACE  ]]; then
      GEOMETRY_KUBECTL_NAMESPACE=default
    fi

    echo "$GEOMETRY_KUBE $GEOMETRY_KUBECTL_VERSION ($GEOMETRY_KUBECTL_CONTEXT:$GEOMETRY_KUBECTL_NAMESPACE)"
}

