# mnml_kube - show kubectl client version and current context/namespace.

(( $+commands[kubectl] )) || return

mnml_kube() {
  ( ${MNML_KUBE_PIN:=false} ) || [[ -f ~/.kube/config ]] || return

  MNML_KUBE=$(ansi ${MNML_KUBE_COLOR:=blue} ${MNML_KUBE_SYMBOL:="⎈"})

  [[ $(kubectl version --client --short) =~ 'Client Version: ([0-9a-zA-Z.]+)' ]]
  local version=$match[1]

  local context="$(kubectl config current-context 2> /dev/null)"
  local namespace="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}" 2> /dev/null)"

  echo -n "$MNML_KUBE $version ($context:${namespace:=default})"
}
