# Ruby
#
# Displays the current ruby and rvm version

: ${GEOMETRY_RUBY_COLOR:=white}      # color
: ${GEOMETRY_RUBY_SYMBOL:="◆"}       # symbol
: ${GEOMETRY_RUBY_SHOW_GEMSET:=true} # Show the gemset name

(( $+commands[ruby] )) || return 1
GEOMETRY_RUBY=$(color $GEOMETRY_RUBY_COLOR $GEOMETRY_RUBY_SYMBOL)

_geometry_get_full_ruby_version() {
  (( $+commands[ruby] )) && GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"
}

_geometry_ruby_version() {
  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]
}

_geometry_get_full_rvm_version() {
  (( $+commands[rvm] )) && GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
}

_geometry_rvm_version() {
  [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
  GEOMETRY_RVM_VERSION=$match[1]
}

_geometry_current_rvm_gemset_name() {
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

function geometry_ruby {
  _geometry_get_full_ruby_version
  _geometry_ruby_version

  local result="$GEOMETRY_RUBY $GEOMETRY_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      _geometry_get_full_rvm_version
      _geometry_rvm_version

      result=$result" ($GEOMETRY_RVM_VERSION"

      # Add current gemset name
      local rvm_gemset_name=$(_geometry_current_rvm_gemset_name)
      if [[ ! -z $rvm_gemset_name ]]; then
          result=$result" $rvm_gemset_name"
      fi

      result=$result")"
  fi

  echo $result
}
