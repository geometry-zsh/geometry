# geometry_hg - display current mercurial branch and status

(( $+commands['hg'] )) || return

geometry_hg() {
  [[ -d .hg ]] || return
  : ${GEOMETRY_HG_COLOR_DIRTY:=red}
  : ${GEOMETRY_HG_COLOR_CLEAN:=green}
  : ${GEOMETRY_HG_COLOR_BRANCH:=242}

  : ${GEOMETRY_HG_SYMBOL_DIRTY:="⬡"}
  : ${GEOMETRY_HG_SYMBOL_CLEAN:="⬢"}
  : ${GEOMETRY_HG_SYMBOL_SEPARATOR:="::"}

  GEOMETRY_HG_DIRTY=$(ansi $GEOMETRY_HG_COLOR_DIRTY $GEOMETRY_HG_SYMBOL_DIRTY)
  GEOMETRY_HG_CLEAN=$(ansi $GEOMETRY_HG_COLOR_CLEAN $GEOMETRY_HG_SYMBOL_CLEAN)

  local branch="$(ansi $GEOMETRY_HG_COLOR_BRANCH $(hg branch 2> /dev/null))"

  local status=$GEOMETRY_HG_CLEAN
  [[ -n $(hg status 2> /dev/null) ]] && status="$GEOMETRY_HG_DIRTY"

  echo "${branch}${GEOMETRY_HG_SYMBOL_SEPARATOR}${status}"
}
