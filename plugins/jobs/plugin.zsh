geometry_prompt_jobs_setup() {
  return true
}

geometry_prompt_jobs_check() {
  return true
}

geometry_prompt_jobs_render() {
  echo '%(1j.[%j].)'
}

geometry_plugin_register jobs

