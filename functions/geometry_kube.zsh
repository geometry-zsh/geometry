# geometry_kube - show kubectl client version and current context/namespace.

(( $+commands[kubectl] )) || return

geometry_kube() {
  ( ${GEOMETRY_KUBE_PIN:=false} ) || [[ ! -z "${KUBECONFIG}" ]] || return

  local geometry_kube=$(ansi ${GEOMETRY_KUBE_COLOR:=blue} ${GEOMETRY_KUBE_SYMBOL:="⎈"})
  local geometry_kube_separator=${GEOMETRY_KUBE_SEPARATOR:="|"}

  if ( ${GEOMETRY_KUBE_VERSION:=true} ); then
    [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
    geometry_kube+=($match[1])
  fi

  local geometry_context="$(kubectl config current-context 2> /dev/null)"
  local geometry_namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}" 2> /dev/null)"

  if [[ ! -z "${GEOMETRY_KUBE_CONTEXT_COLOR}" ]]; then
    geometry_context="$(ansi ${GEOMETRY_KUBE_CONTEXT_COLOR:=white} ${geometry_context})"
  fi

  if [[ ! -z "${GEOMETRY_KUBE_NAMESPACE_COLOR}" ]]; then
    geometry_namespace="$(ansi ${GEOMETRY_KUBE_NAMESPACE_COLOR:=white} ${geometry_namespace:=default})"
  else
    geometry_namespace="${geometry_namespace:=default}"
  fi

  echo -n "${geometry_kube_separator}${geometry_kube} ${geometry_context}:${geometry_namespace}${geometry_kube_separator}"
}
