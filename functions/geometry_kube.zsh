# geometry_kube - show kubectl client version and current context/namespace.

(( $+commands[kubectl] )) || return

geometry_kube() {
  ( ${GEOMETRY_KUBE_PIN:=false} ) || [[ -n "$KUBECONFIG" ]] || return
  : ${GEOMETRY_KUBE_SEPARATOR:="|"}

  # Variable declaration
  local -a geometry_kube
  local kube_symbol
  local kube_context
  local kube_namespace
  local kube_version

  kube_symbol=$(ansi ${GEOMETRY_KUBE_COLOR:=blue} ${GEOMETRY_KUBE_SYMBOL:="⎈"})

  kube_context="$(kubectl config current-context 2> /dev/null)"
  kube_namespace=$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${kube_context}\")].context.namespace}" 2> /dev/null)

  kube_context=$(ansi ${GEOMETRY_KUBE_CONTEXT_COLOR:=default} ${kube_context})
  kube_namespace=$(ansi ${GEOMETRY_KUBE_NAMESPACE_COLOR:=default} ${kube_namespace:=default})

  if ( ${GEOMETRY_KUBE_VERSION:=true} ); then
    [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
    kube_version=($match[1])
  fi

  geometry_kube=($kube_symbol $kube_context $kube_namespace $kube_version)

  echo -n ${(pj.$GEOMETRY_KUBE_SEPARATOR.)geometry_kube}
}
