# Color definitions
GEOMETRY_COLOR_RUBY_RVM_VERSION=${GEOMETRY_COLOR_PROMPT:-white}

# Symbol definitions
GEOMETRY_SYMBOL_RUBY_RVM_VERSION=${GEOMETRY_SYMBOL_RUBY_RVM_VERSION:-"◇"}
GEOMETRY_RUBY_RVM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUBY_RVM_VERSION $GEOMETRY_SYMBOL_RUBY_RVM_VERSION) 

geometry_prompt_ruby_setup() {}

geometry_prompt_ruby_render(){

  if (( ! $+commands[ruby] )); then
      return "";
  fi
  GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"
  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]

  if (( $+commands[rvm] )); then
      GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
      [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
      GEOMETRY_RVM_VERSION=$match[1]
  fi

  result="$GEOMETRY_RUBY_RVM_VERSION $GEOMETRY_RUBY_VERSION"
  if [[ ! -z $GEOMETRY_RVM_VERSION ]]; then
      result=$result" ($GEOMETRY_RVM_VERSION)"
  fi

  echo $result
}

geometry_plugin_register ruby