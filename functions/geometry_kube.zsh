# geometry_kube - show kubectl client version and current context/namespace.

(( $+commands[kubectl] )) || return

geometry_kube() {
  ( ${GEOMETRY_KUBE_PIN:=false} ) || [[ -f ~/.kube/config ]] || return

  GEOMETRY_KUBE=$(ansi ${GEOMETRY_KUBE_COLOR:=blue} ${GEOMETRY_KUBE_SYMBOL:="⎈"})

  [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
  local version=$match[1]

  local context="$(kubectl config current-context 2> /dev/null)"
  local namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}" 2> /dev/null)"

  echo -n "$GEOMETRY_KUBE $version ($context:${namespace:=default})"
}
