# mnml_git - please see the readme for documentation on all features

(( $+commands[git] )) || return

mnml_git_stashes() {
  git rev-parse --quiet --verify refs/stash >/dev/null \
    && ansi ${MNML_GIT_COLOR_STASHES:="144"} ${MNML_GIT_SYMBOL_STASHES:="●"}
}

mnml_git_time() {
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)

  [[ -z "$last_commit" ]] && ansi ${MNML_COLOR_NO_TIME:="white"} ${MNML_GIT_NO_COMMITS_MESSAGE:="no-commits"} && return

  now=$(date +%s)
  seconds_since_last_commit=$((now - last_commit))
  mnml::time $seconds_since_last_commit ${MNML_GIT_TIME_DETAILED:=false}
}

mnml_git_branch() {
  ansi ${MNML_GIT_COLOR_BRANCH:=242} $(git symbolic-ref --short HEAD || git rev-parse --short HEAD)
}

mnml_git_status() {
  : ${MNML_GIT_COLOR_DIRTY:=red}
  : ${MNML_GIT_COLOR_CLEAN:=green}
  : ${MNML_GIT_SYMBOL_DIRTY:="⬡"}
  : ${MNML_GIT_SYMBOL_CLEAN:="⬢"}
  command git rev-parse --git-dir > /dev/null 2>&1 || return
  _status=$([[ -z "$(git status --porcelain --ignore-submodules HEAD)" ]] && [[ -z "$(git ls-files --others --modified --exclude-standard $(git rev-parse --show-toplevel))" ]] && echo CLEAN || echo DIRTY)
  ansi ${(e):-\$MNML_GIT_COLOR_${_status}} ${(e):-\$MNML_GIT_SYMBOL_${_status}}
}

mnml_git_rebase() {
  : ${MNML_GIT_SYMBOL_REBASE:="®"}
  git_dir=$(git rev-parse --git-dir)
  [[ -d "$git_dir/rebase-merge" ]] || [[ -d "$git_dir/rebase-apply" ]] || return
  echo "$MNML_GIT_SYMBOL_REBASE"
}

mnml_git_remote() {
  : ${MNML_GIT_SYMBOL_UNPUSHED:="⇡"}
  : ${MNML_GIT_SYMBOL_UNPULLED:="⇣"}
  : ${MNML_GIT_SYMBOL_CONFLICTS_SOLVED:="◆"}
  : ${MNML_GIT_SYMBOL_CONFLICTS_UNSOLVED:="◈"}

  local_commit=$(git rev-parse "@" 2>/dev/null)
  remote_commit=$(git rev-parse "@{u}" 2>/dev/null)

  [[ $local_commit == "@" || $local_commit == $remote_commit ]] && return

  common_base=$(git merge-base "@" "@{u}" 2>/dev/null) # last common commit
  [[ $common_base == $remote_commit ]] && echo $MNML_GIT_SYMBOL_UNPUSHED && return
  [[ $common_base == $local_commit ]]  && echo $MNML_GIT_SYMBOL_UNPULLED && return

  echo "$MNML_GIT_SYMBOL_UNPUSHED $MNML_GIT_SYMBOL_UNPULLED"
}

mnml_git_symbol() { echo ${(j: :):-$(mnml_git_rebase) $(mnml_git_remote)}; }

mnml_git_conflicts() {
  : ${MNML_GIT_COLOR_CONFLICTS_UNSOLVED:=red}
  : ${MNML_GIT_COLOR_CONFLICTS_SOLVED:=green}
  conflicts=$(git diff --name-only --diff-filter=U)

  [[ -z "$conflicts" ]] && return

  pushd -q $(git rev-parse --show-toplevel)

  local _grep="grep"
  (($+commands[ag])) && _grep="ag"
  (($+commands[rg])) && _grep="rg"

  conflict_list=$(${MNML_GIT_GREP:-$_grep} -cH '^=======$' $conflicts)
  popd -q

  raw_file_count="${#${(@f)conflict_list}}"
  file_count=${raw_file_count##*( )}

  raw_total=$(echo $conflict_list | cut -d ':' -f2 | paste -sd+ - | bc)
  total=${raw_total##*(  )}

  [[ -z "$total" ]] && ansi $MNML_GIT_COLOR_CONFLICTS_SOLVED $MNML_GIT_SYMBOL_CONFLICTS_SOLVED && return

  ansi $MNML_GIT_COLOR_CONFLICTS_UNSOLVED "$MNML_GIT_SYMBOL_CONFLICTS_UNSOLVED (${file_count}f|${total}c)"
}

mnml_git() {
  command git rev-parse --git-dir > /dev/null 2>&1 || return

  $(command git rev-parse --is-bare-repository 2>/dev/null) \
    && ansi ${MNML_GIT_COLOR_BARE:=blue} ${MNML_GIT_SYMBOL_BARE:="⬢"} \
    && return

  echo -n $(mnml_git_symbol) $(mnml_git_branch) \
    $(mnml::git_wrapper \
      $(mnml_git_conflicts) \
      $(mnml_git_time) \
      $(mnml_git_stashes) \
      $(mnml_git_status)
    )
}

mnml::git_wrapper() {
  : ${MNML_GIT_SEPARATOR:=" :: "}
  echo -n ${(pj.$MNML_GIT_SEPARATOR.)$(print -r "$@")}
}
