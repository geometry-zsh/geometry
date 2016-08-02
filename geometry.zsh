# Geometry
# Based on Avit and Pure
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure

# Define how to colorize before the variables
prompt_geometry_colorize() {
  echo "%F{$1}$2%f"
}

# Color definitions
GEOMETRY_COLOR_GIT_DIRTY=${GEOMETRY_COLOR_GIT_DIRTY:-red}
GEOMETRY_COLOR_GIT_CLEAN=${GEOMETRY_COLOR_GIT_CLEAN:-green}
GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED=${GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED:-red}
GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED=${GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED:-green}
GEOMETRY_COLOR_GIT_BRANCH=${GEOMETRY_COLOR_GIT_BRANCH:-242}
GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_SHORT=${GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_SHORT:-green}
GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_NEUTRAL=${GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_NEUTRAL:-white}
GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_LONG=${GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_LONG:-red}
GEOMETRY_COLOR_EXIT_VALUE=${GEOMETRY_COLOR_EXIT_VALUE:-magenta}
GEOMETRY_COLOR_PROMPT=${GEOMETRY_COLOR_PROMPT:-white}
GEOMETRY_COLOR_ROOT=${GEOMETRY_COLOR_ROOT:-red}
GEOMETRY_COLOR_DIR=${GEOMETRY_COLOR_DIR:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_PROMPT=${GEOMETRY_SYMBOL_PROMPT:-"▲"}
GEOMETRY_SYMBOL_RPROMPT=${GEOMETRY_SYMBOL_RPROMPT:-"◇"}
GEOMETRY_SYMBOL_EXIT_VALUE=${GEOMETRY_SYMBOL_EXIT_VALUE:-"△"}
GEOMETRY_SYMBOL_ROOT=${GEOMETRY_SYMBOL_ROOT:-"▲"}
GEOMETRY_SYMBOL_GIT_DIRTY=${GEOMETRY_SYMBOL_GIT_DIRTY:-"⬡"}
GEOMETRY_SYMBOL_GIT_CLEAN=${GEOMETRY_SYMBOL_GIT_CLEAN:-"⬢"}
GEOMETRY_SYMBOL_GIT_REBASE=${GEOMETRY_SYMBOL_GIT_REBASE:-"\uE0A0"}
GEOMETRY_SYMBOL_GIT_UNPULLED=${GEOMETRY_SYMBOL_GIT_UNPULLED:-"⇣"}
GEOMETRY_SYMBOL_GIT_UNPUSHED=${GEOMETRY_SYMBOL_GIT_UNPUSHED:-"⇡"}
GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED=${GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED:-"◆"}
GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED=${GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED:-"◈"}

# Combine color and symbols
GEOMETRY_GIT_DIRTY=$(prompt_geometry_colorize $GEOMETRY_COLOR_GIT_DIRTY $GEOMETRY_SYMBOL_GIT_DIRTY)
GEOMETRY_GIT_CLEAN=$(prompt_geometry_colorize $GEOMETRY_COLOR_GIT_CLEAN $GEOMETRY_SYMBOL_GIT_CLEAN)
GEOMETRY_GIT_REBASE=$GEOMETRY_SYMBOL_GIT_REBASE
GEOMETRY_GIT_UNPULLED=$GEOMETRY_SYMBOL_GIT_UNPULLED
GEOMETRY_GIT_UNPUSHED=$GEOMETRY_SYMBOL_GIT_UNPUSHED
GEOMETRY_EXIT_VALUE=$(prompt_geometry_colorize $GEOMETRY_COLOR_EXIT_VALUE $GEOMETRY_SYMBOL_EXIT_VALUE)
GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)

# Flags
PROMPT_GEOMETRY_GIT_CONFLICTS=${PROMPT_GEOMETRY_GIT_CONFLICTS:-false}
PROMPT_GEOMETRY_GIT_TIME=${PROMPT_GEOMETRY_GIT_TIME:-true}
PROMPT_GEOMETRY_COLORIZE_SYMBOL=${PROMPT_GEOMETRY_COLORIZE_SYMBOL:-false}
PROMPT_GEOMETRY_COLORIZE_ROOT=${PROMPT_GEOMETRY_COLORIZE_ROOT:-false}

# Use ag if possible
GREP=$(which ag &> /dev/null && echo "ag" || echo "grep")

prompt_geometry_git_time_since_commit() {
  if [[ $(git log -1 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
    # Get the last commit.
    last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((seconds_since_last_commit/3600))

    # Sub-hours and sub-minutes
    days=$((seconds_since_last_commit / 86400))
    sub_hours=$((hours % 24))
    sub_minutes=$((minutes % 60))

    if [ $hours -gt 24 ]; then
      commit_age="${days}d"
      color=$GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_LONG
    elif [ $minutes -gt 60 ]; then
      commit_age="${sub_hours}h${sub_minutes}m"
      color=$GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_NEUTRAL
    else
      commit_age="${minutes}m"
      color=$GEOMETRY_COLOR_GIT_TIME_SINCE_COMMIT_SHORT
    fi

    echo "$(prompt_geometry_colorize $color $commit_age)"
  fi
}

prompt_geometry_git_branch() {
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_GIT_BRANCH $ref)"
}

prompt_geometry_git_status() {
  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo $GEOMETRY_GIT_CLEAN
  else
    echo $GEOMETRY_GIT_DIRTY
  fi
}

prompt_geometry_is_rebasing() {
  git_dir=$(git rev-parse --git-dir)
  test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"
}

prompt_geometry_git_rebase_check() {
  if $(prompt_geometry_is_rebasing); then
    echo "$GEOMETRY_GIT_REBASE"
  fi
}

prompt_geometry_git_remote_check() {
  local_commit=$(git rev-parse @ 2>&1)
  remote_commit=$(git rev-parse @{u} 2>&1)
  common_base=$(git merge-base @ @{u} 2>&1) # last common commit

  if [[ $local_commit == $remote_commit ]]; then
    echo ""
  else
    if [[ $common_base == $remote_commit ]]; then
      echo $GEOMETRY_GIT_UNPUSHED
    elif [[ $common_base == $local_commit ]]; then
      echo $GEOMETRY_GIT_UNPULLED
    else
      echo "$GEOMETRY_GIT_UNPUSHED $GEOMETRY_GIT_UNPULLED"
    fi
  fi
}

prompt_geometry_git_symbol() {
  echo "$(prompt_geometry_git_rebase_check) $(prompt_geometry_git_remote_check)"
}

prompt_geometry_git_conflicts() {
  conflicts=$(git diff --name-only --diff-filter=U)
  # echo adds a newline which we want to avoid
  # Using -n prevents from using wc, which searches for newlines
  # and returns 0 when a single file has conflicts
  # Use grep instead
  file_count=$(echo -n "$conflicts" | $GREP -c '^')

  # $file_count contains the amount of files with conflicts
  # in the **BEGINNING** of the merge/rebase.
  if [ "$file_count" -gt 0 ]; then
    # If we have fixed every conflict, $total will be empty
    # So we will check and mark it as good if every conflict is solved
    total=$($GREP -c '^=======$' $conflicts)

    if [[ -z $total ]]; then
      text=$GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED
      color=$GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED
    else
      text="$GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED ($file_count|$total)"
      color=$GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED
    fi

    echo "$(prompt_geometry_colorize $color $text)"
  else
    echo ""
  fi
}

prompt_geometry_git_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if $PROMPT_GEOMETRY_GIT_CONFLICTS; then
      conflicts="$(prompt_geometry_git_conflicts) "
    fi

    if $PROMPT_GEOMETRY_GIT_TIME; then
      time=" $(prompt_geometry_git_time_since_commit) ::"
    fi

    echo "$(prompt_geometry_git_symbol) $(prompt_geometry_git_branch) $conflicts::$time $(prompt_geometry_git_status)"
  fi
}

prompt_geometry_hash_color() {
  local colors=(2 3 4 6 9 12 14)

  if (($(echotc Co) == 256)); then
    colors+=(99 155 47 26)
  fi

  local sum=0
  for for i in {0..${#1}}; do
    ord=$(printf '%d' "'${1[$i]}")
    sum=$(($sum + $ord))
  done

  echo ${colors[$(($sum % ${#colors}))]}
}

prompt_geometry_print_title() {
  print -n '\e]0;'
  print -Pn $1
  print -n '\a'
}

# Show current command in title
prompt_geometry_set_cmd_title() {
  prompt_geometry_print_title "${2} @ %m"
}

# Prevent command showing on title after ending
prompt_geometry_set_title() {
  prompt_geometry_print_title '%~'
}

prompt_geometry_render() {
  PROMPT="
 %(?.$GEOMETRY_PROMPT.$GEOMETRY_EXIT_VALUE) %F{$GEOMETRY_COLOR_DIR}%3~%f "

  PROMPT2=" $GEOMETRY_SYMBOL_RPROMPT "
  RPROMPT="$(prompt_geometry_git_info)%{$reset_color%}"
}

prompt_geometry_setup() {
  autoload -U add-zsh-hook

  if $PROMPT_GEOMETRY_COLORIZE_SYMBOL; then
    export GEOMETRY_COLOR_PROMPT=$(prompt_geometry_hash_color $HOST)
    export GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)
  fi

  if $PROMPT_GEOMETRY_COLORIZE_ROOT && [[ $UID == 0 || $EUID == 0 ]]; then
    export GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_ROOT $GEOMETRY_SYMBOL_ROOT)
  fi

  add-zsh-hook preexec prompt_geometry_set_cmd_title
  add-zsh-hook precmd prompt_geometry_set_title
  add-zsh-hook precmd prompt_geometry_render
}

prompt_geometry_setup
