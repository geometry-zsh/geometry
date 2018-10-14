# geometry_ruby - display the current ruby and rvm version

(( $+commands[ruby] )) || return

: ${GEOMETRY_RUBY_COLOR:=white}      # color
: ${GEOMETRY_RUBY_SYMBOL:="◆"}       # symbol
: ${GEOMETRY_RUBY_SHOW_GEMSET:=true} # Show the gemset name

GEOMETRY_RUBY=$(color $GEOMETRY_RUBY_COLOR $GEOMETRY_RUBY_SYMBOL)

_geometry_ruby_version() {
  [[ $(ruby -v) =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  echo -n $match[1]
}

_geometry_ruby_rvm_version() {
  [[ $(rvm -v) =~ 'rvm ([0-9a-zA-Z.]+)' ]]
  echo -n $match[1]
}

_geometry_ruby_rvm_gemset_name() {
  ( $GEOMETRY_RUBY_RVM_SHOW_GEMSET ) || return
  [[ $(rvm current) =~ 'ruby-[0-9.]+@?(.*)' ]]
  echo ${match[1]:-"default"} # default to "default"
}

function geometry_ruby {
  if (( $+commands[rvm] )); then

      GEOMETRY_RVM="(${(j: :):-$(_geometry_ruby_rvm_version) $(_geometry_ruby_rvm_gemset_name)})"
  fi

  echo -n "${(j: :):-$GEOMETRY_RUBY $(_geometry_ruby_version) $GEOMETRY_RVM}"
}
