# geometry_kube - show kubectl client version and current context/namespace.

(( $+commands[kubectl] )) || return

geometry_kube() {
  ( ${GEOMETRY_KUBE_PIN:=false} ) || [[ ! -z "${KUBECONFIG}" ]] || return

  # Variable declaration
  local -a geometry_kube
  local geometry_kube_separator
  local kube_context
  local kube_namespace

  geometry_kube+=$(ansi ${GEOMETRY_KUBE_COLOR:=blue} ${GEOMETRY_KUBE_SYMBOL:="⎈"})
  geometry_kube_separator=${GEOMETRY_KUBE_SEPARATOR:="|"}

  kube_context="$(kubectl config current-context 2> /dev/null)"
  kube_namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${kube_context}\")].context.namespace}" 2> /dev/null)"
  kube_namespace=${kube_namespace:=default}

  if ( ${GEOMETRY_KUBE_VERSION:=true} ); then
    [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
    geometry_kube+=($match[1])
  fi

  if [[ ! -z "${GEOMETRY_KUBE_CONTEXT_COLOR}" ]]; then
    geometry_kube+=("$(ansi ${GEOMETRY_KUBE_CONTEXT_COLOR} ${kube_context})")
  else
    geometry_kube+=("${kube_context}")
  fi

  if [[ ! -z "${GEOMETRY_KUBE_NAMESPACE_COLOR}" ]]; then
    geometry_kube+=("$(ansi ${GEOMETRY_KUBE_NAMESPACE_COLOR} ${kube_namespace})")
  else
    geometry_kube+=("${kube_namespace}")
  fi

  echo -n "${geometry_kube_separator}${(pj.:.)geometry_kube}${geometry_kube_separator}"

}
