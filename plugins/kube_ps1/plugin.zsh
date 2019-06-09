geometry_prompt_kube_ps1_setup() {}

geometry_prompt_kube_ps1_check() {
  if [[ -z "$KUBE_PS1_ENABLED" ]]; then
		return 1
	fi
}

geometry_prompt_kube_ps1_render() {
  local render="$(prompt_geometry_git_symbol)"

  if [[ -n $render ]]; then
    render+=" "
  fi

  render+="$(kube_ps1) "

  echo -n $render
}

