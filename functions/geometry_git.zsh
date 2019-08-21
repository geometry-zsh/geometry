# geometry_git - please see the readme for documentation on all features

(( $+commands[git] )) || return

geometry_git_stashes() {
  git rev-parse --quiet --verify refs/stash >/dev/null \
    && ansi ${GEOMETRY_GIT_COLOR_STASHES:="144"} ${GEOMETRY_GIT_SYMBOL_STASHES:="●"}
}

geometry_git_time() {
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)

  [[ -z "$last_commit" ]] && ansi ${GEOMETRY_COLOR_NO_TIME:="white"} ${GEOMETRY_GIT_NO_COMMITS_MESSAGE:="no-commits"} && return

  local now=$(date +%s)
  local seconds_since_last_commit=$((now - last_commit))
  geometry::time $seconds_since_last_commit ${GEOMETRY_GIT_TIME_DETAILED:=false}
}

geometry_git_branch() {
  ansi ${GEOMETRY_GIT_COLOR_BRANCH:=242} $(git symbolic-ref --short HEAD || git rev-parse --short HEAD)
}

geometry_git_status() {
  : ${GEOMETRY_GIT_COLOR_DIRTY:=red}
  : ${GEOMETRY_GIT_COLOR_CLEAN:=green}
  : ${GEOMETRY_GIT_SYMBOL_DIRTY:="⬡"}
  : ${GEOMETRY_GIT_SYMBOL_CLEAN:="⬢"}
  command git rev-parse --git-dir > /dev/null 2>&1 || return
  local _status=$([[ -z "$(git status --porcelain --ignore-submodules HEAD)" ]] && [[ -z "$(git ls-files --others --modified --exclude-standard $(git rev-parse --show-toplevel))" ]] && echo CLEAN || echo DIRTY)
  ansi ${(e):-\$GEOMETRY_GIT_COLOR_${_status}} ${(e):-\$GEOMETRY_GIT_SYMBOL_${_status}}
}

geometry_git_rebase() {
  : ${GEOMETRY_GIT_SYMBOL_REBASE:="®"}
  local git_dir=$(git rev-parse --git-dir)
  [[ -d "$git_dir/rebase-merge" ]] || [[ -d "$git_dir/rebase-apply" ]] || return
  echo "$GEOMETRY_GIT_SYMBOL_REBASE"
}

geometry_git_remote() {
  : ${GEOMETRY_GIT_SYMBOL_UNPUSHED:="⇡"}
  : ${GEOMETRY_GIT_SYMBOL_UNPULLED:="⇣"}
  : ${GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED:="◆"}
  : ${GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED:="◈"}

  local local_commit=$(git rev-parse "@" 2>/dev/null)
  local remote_commit=$(git rev-parse "@{u}" 2>/dev/null)

  [[ $local_commit == "@" || $local_commit == $remote_commit ]] && return

  local common_base=$(git merge-base "@" "@{u}" 2>/dev/null) # last common commit
  [[ $common_base == $remote_commit ]] && echo $GEOMETRY_GIT_SYMBOL_UNPUSHED && return
  [[ $common_base == $local_commit ]]  && echo $GEOMETRY_GIT_SYMBOL_UNPULLED && return

  echo "$GEOMETRY_GIT_SYMBOL_UNPUSHED $GEOMETRY_GIT_SYMBOL_UNPULLED"
}

geometry_git_symbol() { echo ${(j: :):-$(geometry_git_rebase) $(geometry_git_remote)}; }

geometry_git_conflicts() {
  : ${GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED:=red}
  : ${GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED:=green}
  local conflicts=$(git diff --name-only --diff-filter=U)

  [[ -z "$conflicts" ]] && return

  pushd -q $(git rev-parse --show-toplevel)

  local _grep="grep"
  (($+commands[ag])) && _grep="ag"
  (($+commands[rg])) && _grep="rg"

  local conflict_list=$(${GEOMETRY_GIT_GREP:-$_grep} -cH '^=======$' $conflicts)
  popd -q

  local raw_file_count="${#${(@f)conflict_list}}"
  local file_count=${raw_file_count##*( )}

  local raw_total=$(echo $conflict_list | cut -d ':' -f2 | paste -sd+ - | bc)
  local total=${raw_total##*(  )}

  [[ -z "$total" ]] && ansi $GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED $GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED && return

  ansi $GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED "$GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED (${file_count}f|${total}c)"
}

geometry_git() {
  command git rev-parse --git-dir > /dev/null 2>&1 || return

  $(command git rev-parse --is-bare-repository 2>/dev/null) \
    && ansi ${GEOMETRY_GIT_COLOR_BARE:=blue} ${GEOMETRY_GIT_SYMBOL_BARE:="⬢"} \
    && return

  echo -n $(geometry_git_symbol) $(geometry_git_branch) \
    $(geometry::git_wrapper \
      $(geometry_git_conflicts) \
      $(geometry_git_time) \
      $(geometry_git_stashes) \
      $(geometry_git_status)
    )
}

geometry::git_wrapper() {
  : ${GEOMETRY_GIT_SEPARATOR:=" :: "}
  echo -n ${(pj.$GEOMETRY_GIT_SEPARATOR.)$(print -r "$@")}
}
