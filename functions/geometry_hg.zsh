# Mercurial
#
# Displays current branch and status

: ${GEOMETRY_HG_COLOR_DIRTY:=red}
: ${GEOMETRY_HG_COLOR_CLEAN:=green}
: ${GEOMETRY_HG_COLOR_BRANCH:=242}

: ${GEOMETRY_HG_SYMBOL_DIRTY:="⬡"}
: ${GEOMETRY_HG_SYMBOL_CLEAN:="⬢"}
: ${GEOMETRY_HG_SYMBOL_SEPARATOR:="::"}

(( $+commands['hg'] )) || return 1

GEOMETRY_HG_DIRTY=$(color $GEOMETRY_HG_COLOR_DIRTY $GEOMETRY_HG_SYMBOL_DIRTY)
GEOMETRY_HG_CLEAN=$(color $GEOMETRY_HG_COLOR_CLEAN $GEOMETRY_HG_SYMBOL_CLEAN)

geometry_prompt_hg_branch() {
  local ref=$(hg branch 2> /dev/null) || return
  echo "$(color $GEOMETRY_HG_COLOR_BRANCH $ref)"
}

# Checks if working tree is dirty
geometry_prompt_hg_status() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$GEOMETRY_HG_DIRTY"
  else
    echo "$GEOMETRY_HG_CLEAN"
  fi
}

function geometry_hg {
  test -d .hg || return 1
  echo "$(geometry_prompt_hg_branch) ${GEOMETRY_HG_SYMBOL_SEPARATOR} $(geometry_prompt_hg_status)"
}
