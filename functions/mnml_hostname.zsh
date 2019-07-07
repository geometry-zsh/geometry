# mnml_hostname - show user@hostname

mnml_hostname() {
  local _host=${HOST:-$HOSTNAME}
  [[ "$_host" = "${MNML_HOSTNAME_HIDE_ON:=localhost}" ]] && return
  echo -n "${USER}${MNML_HOSTNAME_SEPARATOR:=@}${_host}"
}
