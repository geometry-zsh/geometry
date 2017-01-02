GEOMETRY_COLOR_HG_DIRTY=${GEOMETRY_COLOR_HG_DIRTY:-red}
GEOMETRY_COLOR_HG_CLEAN=${GEOMETRY_COLOR_HG_CLEAN:-green}
GEOMETRY_COLOR_HG_BRANCH=${GEOMETRY_COLOR_HG_BRANCH:-242}

GEOMETRY_SYMBOL_HG_DIRTY=${GEOMETRY_SYMBOL_HG_DIRTY:-"⬡"}
GEOMETRY_SYMBOL_HG_CLEAN=${GEOMETRY_SYMBOL_HG_CLEAN:-"⬢"}
GEOMETRY_SYMBOL_HG_SEPARATOR=${GEOMETRY_SYMBOL_HG_SEPARATOR:-"::"}

GEOMETRY_HG_DIRTY=$(prompt_geometry_colorize $GEOMETRY_COLOR_HG_DIRTY $GEOMETRY_SYMBOL_HG_DIRTY) 
GEOMETRY_HG_CLEAN=$(prompt_geometry_colorize $GEOMETRY_COLOR_HG_CLEAN $GEOMETRY_SYMBOL_HG_CLEAN) 

geometry_prompt_hg_branch() {
  local ref=$(hg branch 2> /dev/null) || return
  echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_HG_BRANCH $ref)"
}

# Checks if working tree is dirty
geometry_prompt_hg_status() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$GEOMETRY_HG_DIRTY"
  else
    echo "$GEOMETRY_HG_CLEAN"
  fi
}

geometry_prompt_hg_setup() {
  return $+commands['hg'];
}

geometry_prompt_hg_render() {
  if [[ -d $PWD/.hg ]]; then
    echo "$(geometry_prompt_hg_branch) ${GEOMETRY_SYMBOL_HG_SEPARATOR} $(geometry_prompt_hg_status)"
  fi
}

geometry_plugin_register hg

