# Kube
#
# Displays kubectl client version and current context/namespace.

: ${GEOMETRY_KUBE_COLOR:=blue} # Color
: ${GEOMETRY_KUBE_SYMBOL:="⎈"} # Symbol
: ${GEOMETRY_KUBE_PIN:=false}  # Always display?

(( $+commands[kubectl] )) || return 1

GEOMETRY_KUBE=$(color $GEOMETRY_KUBE_COLOR $GEOMETRY_KUBE_SYMBOL)

_geometry_get_full_kubectl_version() {
  (( $+commands[kubectl] )) && GEOMETRY_KUBECTL_VERSION_FULL="$(kubectl version --client --short)"
}

_geometry_kubectl_version() {
  [[ $GEOMETRY_KUBECTL_VERSION_FULL =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_KUBECTL_VERSION=$match[1]
}

_geometry_kube_config() {
  GEOMETRY_KUBECTL_CONTEXT="$(kubectl config current-context 2> /dev/null)"
  GEOMETRY_KUBECTL_NAMESPACE="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$GEOMETRY_KUBECTL_CONTEXT\")].context.namespace}" 2> /dev/null)"
}

function geometry_kube {
    { test $GEOMETRY_KUBE_PIN || test -f ~/.kube/config } || return
    _geometry_get_full_kubectl_version
    _geometry_kubectl_version
    _geometry_kube_config

    if [[ -z $GEOMETRY_KUBECTL_NAMESPACE  ]]; then
      GEOMETRY_KUBECTL_NAMESPACE=default
    fi

    echo -n "$GEOMETRY_KUBE $GEOMETRY_KUBECTL_VERSION ($GEOMETRY_KUBECTL_CONTEXT:$GEOMETRY_KUBECTL_NAMESPACE)"
}

