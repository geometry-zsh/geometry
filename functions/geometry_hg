# geometry_hg - display current mercurial branch and status

geometry_hg() {
  (( $+commands[hg] )) || return 1
  [[ -d .hg ]] || return 2

  local branch="$(ansi ${GEOMETRY_HG_COLOR_BRANCH:=242} "$(hg branch 2> /dev/null)")"

  [[ -n "$(hg status 2> /dev/null)" ]] \
    && local symbol="$(ansi ${GEOMETRY_HG_COLOR_DIRTY:=red} ${GEOMETRY_HG_SYMBOL_DIRTY:="⬡"})" \
    || local symbol="$(ansi ${GEOMETRY_HG_COLOR_CLEAN:=green} ${GEOMETRY_HG_SYMBOL_CLEAN:="⬢"})"

  echo -n "${branch}${GEOMETRY_HG_SYMBOL_SEPARATOR:=::}${symbol}"
}
