# mnml_hg - display current mercurial branch and status

mnml_hg() {
  (( $+commands[hg] )) || return 1
  [[ -d .hg ]] || return 2

  local branch="$(ansi ${MNML_HG_COLOR_BRANCH:=242} $(hg branch 2> /dev/null))"

  [[ -n "$(hg status 2> /dev/null)" ]] \
    && local symbol=$(ansi ${MNML_HG_COLOR_DIRTY:=red} ${MNML_HG_SYMBOL_DIRTY:="⬡"}) \
    || local symbol=$(ansi ${MNML_HG_COLOR_CLEAN:=green} ${MNML_HG_SYMBOL_CLEAN:="⬢"})

  echo -n "${branch}${MNML_HG_SYMBOL_SEPARATOR:='::'}${symbol}"
}
