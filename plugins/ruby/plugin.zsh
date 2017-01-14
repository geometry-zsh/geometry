# Color definitions
GEOMETRY_COLOR_RUBY_RVM_VERSION=${GEOMETRY_COLOR_PROMPT:-white}

# Symbol definitions
GEOMETRY_SYMBOL_RUBY_RVM_VERSION=${GEOMETRY_SYMBOL_RUBY_RVM_VERSION:-"◆"}
GEOMETRY_RUBY_RVM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUBY_RVM_VERSION $GEOMETRY_SYMBOL_RUBY_RVM_VERSION) 

get_full_ruby_version() {
  if (( $+commands[ruby] )) && [[ -z $GEOMETRY_RUBY_VERSION_FULL ]]; then
      GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"
  fi
}

get_full_rvm_version() {
  if (( $+commands[rvm] )) && [[ -z $GEOMETRY_RVM_VERSION_FULL ]]; then
      GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
  fi
}

geometry_prompt_ruby_setup() {
  GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"

  GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
}

geometry_prompt_ruby_render() {

  if (( ! $+commands[ruby] )); then
      return "";
  fi
  get_full_ruby_version
  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]

  result="$GEOMETRY_RUBY_RVM_VERSION $GEOMETRY_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      get_full_rvm_version
      [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
      GEOMETRY_RVM_VERSION=$match[1]
      result=$result" ($GEOMETRY_RVM_VERSION)"
  fi

  echo $result
}

geometry_plugin_register ruby