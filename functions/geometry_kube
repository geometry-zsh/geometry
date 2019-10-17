# geometry_kube - show kubectl client version and current context/namespace.
geometry_kube_symbol() {
  ansi ${GEOMETRY_KUBE_COLOR:=blue} ${GEOMETRY_KUBE_SYMBOL:="⎈"}
}

geometry_kube_namespace() {
  local kube_namespace="$(kubectl config view --minify --output "jsonpath={..namespace}" 2> /dev/null)"
  ansi ${GEOMETRY_KUBE_NAMESPACE_COLOR:=default} ${kube_namespace:=default}
}

geometry_kube_context() {
  local kube_context="$(kubectl config current-context 2> /dev/null)"
  ansi ${GEOMETRY_KUBE_CONTEXT_COLOR:=default} ${kube_context}
}

geometry_kube_version() {
  [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
  local kube_version=($match[1])
  ansi ${GEOMETRY_KUBE_VERSION_COLOR:=default} ${kube_version:=default}
}

geometry_kube() {
  (( $+commands[kubectl] )) || return

  ( ${GEOMETRY_KUBE_PIN:=true} ) || return

  ( ${GEOMETRY_KUBE_PIN:=false} ) || [[ -n "$KUBECONFIG" ]] || [[ -n "$(kubectl config current-context 2> /dev/null)" ]] || return

  local geometry_kube_details && geometry_kube_details=(
    $(geometry_kube_symbol)
    $(geometry_kube_context)
    $(geometry_kube_namespace)
    $(geometry_kube_version)
  )

  local separator=${GEOMETRY_KUBE_SEPARATOR:-"|"}
  echo -n ${(pj.$separator.)geometry_kube_details}
}
