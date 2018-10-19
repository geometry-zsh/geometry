# geometry_git - please see geometry_git.md for the full readme

(( $+commands[git] )) || return

_stashes() {
  git rev-parse --quiet --verify refs/stash >/dev/null && echo $GEOMETRY_GIT_STASHES
}

_time() {
  # Defaults to "", which would hide the time_since_commit block
  local time_since_commit=""

  # Get the last commit.
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)
  if [[ -n $last_commit ]]; then
      now=$(date +%s)
      seconds_since_last_commit=$((now - last_commit))
      time_since_commit=$(_geometry_seconds_to_human_time $seconds_since_last_commit $GEOMETRY_GIT_TIME_SHOW_LONG_FORMAT)
  elif $GEOMETRY_GIT_TIME_SHOW_EMPTY; then
      time_since_commit=$(color $GEOMETRY_COLOR_NO_TIME $GEOMETRY_GIT_NO_COMMITS_MESSAGE)
  fi

  test -n "$time_since_commit" && echo $_
}

_branch() {
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$(color $GEOMETRY_GIT_COLOR_BRANCH $ref)"
}

_status() {
  if test -z "$(git status --porcelain --ignore-submodules HEAD)"; then
    if test -z "$(git ls-files --others --modified --exclude-standard)"; then
      echo $GEOMETRY_GIT_CLEAN
      return
    fi
  fi
  echo $GEOMETRY_GIT_DIRTY
}

_rebase() {
  git_dir=$(git rev-parse --git-dir)
  test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply" || return
  echo "$GEOMETRY_GIT_REBASE"
}

_remote() {
  local_commit=$(git rev-parse "@" 2>/dev/null)
  remote_commit=$(git rev-parse "@{u}" 2>/dev/null)

  [[ $local_commit == "@" || $local_commit == $remote_commit ]] && return

  common_base=$(git merge-base "@" "@{u}" 2>/dev/null) # last common commit
  if [[ $common_base == $remote_commit ]]; then
    echo $GEOMETRY_GIT_UNPUSHED
  elif [[ $common_base == $local_commit ]]; then
    echo $GEOMETRY_GIT_UNPULLED
  else
    echo "$GEOMETRY_GIT_UNPUSHED $GEOMETRY_GIT_UNPULLED"
  fi
}

_symbol() {
  echo ${(j: :):-$(_rebase) $(_remote)}
}

_conflicts() {
  conflicts=$(git diff --name-only --diff-filter=U)

  if [[ ! -z $conflicts ]]; then
    pushd -q $(git rev-parse --show-toplevel)

    local _grep="grep"
    (($+commands[ag])) && _grep="ag"
    (($+commands[rg])) && _grep="rg"

    conflict_list=$(${GEOMETRY_GIT_GREP:-$_grep} -cH '^=======$' $(echo $conflicts))
    popd -q

    raw_file_count=$(echo $conflict_list | cut -d ':' -f1 | wc -l)
    file_count=${raw_file_count##*( )}

    raw_total=$(echo $conflict_list | cut -d ':' -f2 | paste -sd+ - | bc)
    total=${raw_total##*(  )}

    if [[ -z $total ]]; then
      text=$GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED
      highlight=$GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED
    else
      text="$GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED (${file_count}f|${total}c)"
      highlight=$GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED
    fi

    echo "$(color $highlight $text) "
  else
    echo ""
  fi
}

function geometry_git {
  command git rev-parse --git-dir > /dev/null 2>&1 || return

  # Color definitions
  : ${GEOMETRY_GIT_COLOR_DIRTY:=red}
  : ${GEOMETRY_GIT_COLOR_CLEAN:=green}
  : ${GEOMETRY_GIT_COLOR_BARE:=blue}
  : ${GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED:=red}
  : ${GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED:=green}
  : ${GEOMETRY_GIT_COLOR_BRANCH:=242}
  : ${GEOMETRY_GIT_COLOR_STASHES:="144"}

  # Symbol definitions
  : ${GEOMETRY_GIT_SYMBOL_DIRTY:="⬡"}
  : ${GEOMETRY_GIT_SYMBOL_CLEAN:="⬢"}
  : ${GEOMETRY_GIT_SYMBOL_BARE:="⬢"}
  : ${GEOMETRY_GIT_SYMBOL_REBASE:="\uE0A0"}
  : ${GEOMETRY_GIT_SYMBOL_UNPUSHED:="⇡"}
  : ${GEOMETRY_GIT_SYMBOL_UNPULLED:="⇣"}
  : ${GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED:="◆"}
  : ${GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED:="◈"}
  : ${GEOMETRY_GIT_SYMBOL_STASHES:="●"}

  # Flags
  : ${GEOMETRY_GIT_SHOW_CONFLICTS:=false}
  : ${GEOMETRY_GIT_SHOW_TIME:=true}
  : ${GEOMETRY_GIT_TIME_LONG_FORMAT:=false}
  : ${GEOMETRY_GIT_TIME_SHOW_EMPTY:=true}
  : ${GEOMETRY_GIT_SHOW_STASHES:=true}

  # Misc configurations
  : ${GEOMETRY_GIT_NO_COMMITS_MESSAGE:="no commits"}
  : ${GEOMETRY_GIT_SEPARATOR:="::"}

  # Combine color and symbols
  GEOMETRY_GIT_DIRTY=$(color $GEOMETRY_GIT_COLOR_DIRTY $GEOMETRY_GIT_SYMBOL_DIRTY)
  GEOMETRY_GIT_CLEAN=$(color $GEOMETRY_GIT_COLOR_CLEAN $GEOMETRY_GIT_SYMBOL_CLEAN)
  GEOMETRY_GIT_BARE=$(color $GEOMETRY_GIT_COLOR_BARE $GEOMETRY_GIT_SYMBOL_BARE)
  GEOMETRY_GIT_STASHES=$(color $GEOMETRY_GIT_COLOR_STASHES $GEOMETRY_GIT_SYMBOL_STASHES)
  GEOMETRY_GIT_REBASE=$GEOMETRY_GIT_SYMBOL_REBASE
  GEOMETRY_GIT_UNPULLED=$GEOMETRY_GIT_SYMBOL_UNPULLED
  GEOMETRY_GIT_UNPUSHED=$GEOMETRY_GIT_SYMBOL_UNPUSHED

  $(command git rev-parse --is-bare-repository 2>/dev/null) && echo "$GEOMETRY_GIT_BARE" && return

  local render=(${(j: :):-$(_symbol) $(_branch)})

  $GEOMETRY_GIT_SHOW_CONFLICTS && render[0]+=" $(_conflicts)"

  $GEOMETRY_GIT_SHOW_TIME && render+=$(_time)

  $GEOMETRY_GIT_SHOW_STASHES && render+=$(_stashes)

  render+=$(_status)

  echo ${(pj.$GEOMETRY_GIT_SEPARATOR.)render}
}
