# Color definitions
GEOMETRY_COLOR_RUBY_RVM_VERSION=${GEOMETRY_COLOR_PROMPT:-white}

GEOMETRY_RUBY_RVM_SHOW_GEMSET=${GEOMETRY_RUBY_RVM_SHOW_GEMSET:-true}

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

prompt_geometry_ruby_setup() {
  get_full_ruby_version

  get_full_rvm_version
}

current_rvm_gemset_name() {
  if $GEOMETRY_RUBY_RVM_SHOW_GEMSET; then
      local cur_dir=$(pwd)
      local gemset_name=$(cd "$(pwd)" && rvm current)
      [[ $gemset_name =~ 'ruby-[0-9.]+@?(.*)' ]]

      # If no name present, then it's the default gemset
      if [[ -z $match[1] ]]; then
          return "default"
      else
          return $match[1]
      fi
  else
    return ""
  fi
}

prompt_geometry_ruby_render() {
  if (( ! $+commands[ruby] )); then
      return "";
  fi

  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]

  local result="$GEOMETRY_RUBY_RVM_VERSION $GEOMETRY_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
      GEOMETRY_RVM_VERSION=$match[1]
      result=$result" ($GEOMETRY_RVM_VERSION"

      # Add current gemset name
      local rvm_gemset_name=$current_rvm_gemset_name
      if [[ ! -z $rvm_gemset_name ]]; then
          result=$result" $rvm_gemset_name"
      fi

      result=$result")"
  fi

  echo $result
}

geometry_plugin_register ruby