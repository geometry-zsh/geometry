# mnml_ruby - display the current ruby version, rvm version, and gemset

(( $+commands[ruby] )) || return

mnml_ruby() {
  MNML_RUBY=$(ansi ${MNML_RUBY_COLOR:=white} ${MNML_RUBY_SYMBOL:="◆"})

  [[ $(ruby -v) =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  local ruby_version=$match[1]

  (( $+commands[rvm] )) && {
    [[ $(rvm -v) =~ 'rvm ([0-9a-zA-Z.]+)' ]]
    local rvm_version=$match[1]


    ( ${MNML_RUBY_RVM_SHOW_GEMSET:=true} ) && {
      [[ $(rvm current) =~ 'ruby-[0-9.]+@?(.*)' ]]
      local gemset=${match[1]:-"default"}
    }
  }

  echo -n "${(j: :):-$MNML_RUBY $ruby_version $rvm_version $gemset}"
}
