# geometry_ruby - display the current ruby version, rvm version, and gemset

geometry_ruby() {
  (( $+commands[ruby] )) || return

  GEOMETRY_RUBY=$(ansi ${GEOMETRY_RUBY_COLOR:=default} ${GEOMETRY_RUBY_SYMBOL:="◆"})

  [[ $(ruby -v) =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  local ruby_version=$match[1]

  (( $+commands[rvm] )) && {
    [[ $(rvm -v) =~ 'rvm ([0-9a-zA-Z.]+)' ]]
    local rvm_version=$match[1]


    ( ${GEOMETRY_RUBY_RVM_SHOW_GEMSET:=true} ) && {
      [[ $(rvm current) =~ 'ruby-[0-9.]+@?(.*)' ]]
      local gemset=${match[1]:-"default"}
    }
  }

  echo -n "${(j: :):-$GEOMETRY_RUBY $ruby_version $rvm_version $gemset}"
}
