# Color definitions
GEOMETRY_COLOR_RUBY_RVM_VERSION=${GEOMETRY_COLOR_PROMPT:-white}

GEOMETRY_RUBY_RVM_SHOW_GEMSET=${GEOMETRY_RUBY_RVM_SHOW_GEMSET:-true}

# Symbol definitions
GEOMETRY_SYMBOL_RUBY_RVM_VERSION=${GEOMETRY_SYMBOL_RUBY_RVM_VERSION:-"◆"}
GEOMETRY_RUBY_RVM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUBY_RVM_VERSION $GEOMETRY_SYMBOL_RUBY_RVM_VERSION) 

prompt_geometry_get_full_ruby_version() {
  (( $+commands[ruby] )) && GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"
}

prompt_geometry_ruby_version() {
  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]
}

prompt_geometry_get_full_rvm_version() {
  (( $+commands[rvm] )) && GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
}

prompt_geometry_rvm_version() {
  [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
  GEOMETRY_RVM_VERSION=$match[1]
}

geometry_prompt_ruby_setup() {
  (( $+commands[ruby] )) || return 1
}

geometry_prompt_ruby_check() {}

prompt_geometry_current_rvm_gemset_name() {
  if $GEOMETRY_RUBY_RVM_SHOW_GEMSET; then
      local cur_dir=$(pwd)
      local gemset_name=$(rvm current)
      [[ $gemset_name =~ 'ruby-[0-9.]+@?(.*)' ]]

      # If no name present, then it's the default gemset
      if [[ -z $match[1] ]]; then
          echo "default"
      else
          echo $match[1]
      fi
  fi
}

geometry_prompt_ruby_render() {
  prompt_geometry_get_full_ruby_version
  prompt_geometry_ruby_version

  local result="$GEOMETRY_RUBY_RVM_VERSION $GEOMETRY_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      prompt_geometry_get_full_rvm_version
      prompt_geometry_rvm_version

      result=$result" ($GEOMETRY_RVM_VERSION"

      # Add current gemset name
      local rvm_gemset_name=$( prompt_geometry_current_rvm_gemset_name )
      if [[ ! -z $rvm_gemset_name ]]; then
          result=$result" $rvm_gemset_name"
      fi

      result=$result")"
  fi

  echo $result
}
