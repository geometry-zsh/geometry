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
GEOMETRY_COLOR_EXIT_VALUE=${GEOMETRY_COLOR_EXIT_VALUE:-magenta}
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_PROMPT:-green}
GEOMETRY_COLOR_PROMPT=${GEOMETRY_COLOR_PROMPT:-white}
GEOMETRY_COLOR_ROOT=${GEOMETRY_COLOR_ROOT:-red}
GEOMETRY_COLOR_DIR=${GEOMETRY_COLOR_DIR:-blue}
GEOMETRY_COLOR_TIME_SHORT=${GEOMETRY_COLOR_TIME_SHORT:-green}
GEOMETRY_COLOR_TIME_NEUTRAL=${GEOMETRY_COLOR_TIME_NEUTRAL:-white}
GEOMETRY_COLOR_TIME_LONG=${GEOMETRY_COLOR_TIME_LONG:-red}
GEOMETRY_COLOR_NO_TIME=${GEOMETRY_COLOR_NO_TIME:-red}

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
PROMPT_GEOMETRY_GIT_ASYNC=${PROMPT_GEOMETRY_GIT_ASYNC:-true}
PROMPT_GEOMETRY_EXEC_TIME=${PROMPT_GEOMETRY_EXEC_TIME:-false}
PROMPT_GEOMETRY_COLORIZE_SYMBOL=${PROMPT_GEOMETRY_COLORIZE_SYMBOL:-false}
PROMPT_GEOMETRY_COLORIZE_ROOT=${PROMPT_GEOMETRY_COLORIZE_ROOT:-false}
PROMPT_VIRTUALENV_ENABLED=${PROMPT_VIRTUALENV_ENABLED:-false}
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}
PROMPT_GEOMETRY_GIT_TIME_SHORT_FORMAT=${PROMPT_GEOMETRY_GIT_TIME_SHORT_FORMAT:-true}
PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY=${PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY:-true}

# Misc configurations
GEOMETRY_ASYNC_PROMPT_TMP_FILENAME=${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME:-/tmp/geometry-prompt-git-info-}
GEOMETRY_GIT_NO_COMMITS_MESSAGE=${GEOMETRY_GIT_NO_COMMITS_MESSAGE:-"no commits"}
GEOMETRY_PROMPT_PREFIX=${GEOMETRY_PROMPT_PREFIX:-"
"}

# Choose best version of grep
prompt_geometry_set_grep() {
  (command -v rg >/dev/null 2>&1 && echo "rg") \
  || (command -v ag >/dev/null 2>&1 && echo "ag") \
  || echo "grep"
}

GEOMETRY_GREP=${GREP:-$(prompt_geometry_set_grep)}

# from https://github.com/sindresorhus/pretty-time-zsh
prompt_geometry_seconds_to_human_time() {
  local color=""
  local human="" total_seconds=$1
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  if $PROMPT_GEOMETRY_GIT_TIME_SHORT_FORMAT; then
    if (( days > 0 )); then
        human="${days}d"
        color=$GEOMETRY_COLOR_TIME_LONG
    elif (( hours > 0 )); then
        human="${hours}h"
        color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
    elif (( minutes > 0 )); then
        human="${minutes}m"
        color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
    else
        human="${seconds}s"
        color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
    fi
  else
    (( days > 0 )) && human+="${days}d " && color=$GEOMETRY_COLOR_TIME_LONG
    (( hours > 0 )) && human+="${hours}h " && color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
    (( minutes > 0 )) && human+="${minutes}m "
    human+="${seconds}s" && color=${color:-$GEOMETRY_COLOR_TIME_SHORT}
  fi

  echo "$(prompt_geometry_colorize $color $human)"
}

# stores (into prompt_geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_geometry_check_command_exec_time() {
  integer elapsed
  (( elapsed = EPOCHSECONDS - ${prompt_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME )); then
    export prompt_geometry_command_exec_time="$(prompt_geometry_seconds_to_human_time $elapsed) "
  fi
}

prompt_geometry_git_time_since_commit() {
  # Defaults to "", which would hide the git_time_since_commit block
  local git_time_since_commit=""

  # Get the last commit.
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)
  if [[ $last_commit ]]; then
      now=$(date +%s)
      seconds_since_last_commit=$((now - last_commit))
      git_time_since_commit=$(prompt_geometry_seconds_to_human_time $seconds_since_last_commit)
  elif $PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY; then
      git_time_since_commit=$(prompt_geometry_colorize $GEOMETRY_COLOR_NO_TIME $GEOMETRY_GIT_NO_COMMITS_MESSAGE)
  fi

  echo $git_time_since_commit
}

prompt_geometry_git_branch() {
  ref=$(git symbolic-ref --short HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_GIT_BRANCH $ref)"
}

prompt_geometry_virtualenv() {
  if test ! -z $VIRTUAL_ENV && $PROMPT_VIRTUALENV_ENABLED; then
    ref=$(basename $VIRTUAL_ENV) || return
    echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV "(${ref})") "
  fi
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
  local_commit=$(git rev-parse "@" 2>&1)
  remote_commit=$(git rev-parse "@{u}" 2>&1)
  common_base=$(git merge-base "@" "@{u}" 2>&1) # last common commit

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

  if [[ ! -z $conflicts ]]; then
    conflict_list=$($GEOMETRY_GREP -cH '^=======$' $(echo $conflicts))

    raw_file_count=$(echo $conflict_list | cut -d ':' -f1 | wc -l)
    file_count=${raw_file_count##*( )}

    raw_total=$(echo $conflict_list | cut -d ':' -f2 | paste -sd+ - | bc)
    total=${raw_total##*(  )}

    if [[ -z $total ]]; then
      text=$GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED
      color=$GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED
    else
      text="$GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED ($file_count|$total)"
      color=$GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED
    fi

    echo "$(prompt_geometry_colorize $color $text) "
  else
    echo ""
  fi
}

prompt_geometry_git_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if $PROMPT_GEOMETRY_GIT_CONFLICTS ; then
      conflicts="$(prompt_geometry_git_conflicts)"
    fi

    if $PROMPT_GEOMETRY_GIT_TIME; then
      local git_time_since_commit=$(prompt_geometry_git_time_since_commit)
      if [[ $git_time_since_commit ]]; then
          time=" $git_time_since_commit ::"
      fi
    fi

    echo "$(prompt_geometry_git_symbol) $(prompt_geometry_git_branch) $conflicts::$time $(prompt_geometry_git_status)"
  fi
}

prompt_geometry_hash_color() {
  colors=(2 3 4 6 9 12 14)

  if (($(echotc Co) == 256)); then
    colors+=(99 155 47 26)
  fi

  local sum=0
  for i in {0..${#1}}; do
    ord=$(printf '%d' "'${1[$i]}")
    sum=$(($sum + $ord))
  done

  echo ${colors[$(($sum % ${#colors}))]}
}

prompt_geometry_print_title() {
}

# Show current command in title
prompt_geometry_set_cmd_title() {
  local COMMAND="${2}"
  local CURR_DIR="${PWD##*/}"
  print -n '\e]0;'
  print -Pn '$COMMAND @ $CURR_DIR'
  print -n '\a'
}

# Prevent command showing on title after ending
prompt_geometry_set_title() {
  print -n '\e]0;'
  print -Pn '%~'
  print -n '\a'
}

prompt_geometry_render_rprompt() {
    local exec_time=$prompt_geometry_command_exec_time
    echo $exec_time $virtualenv $(prompt_geometry_git_info) $(prompt_geometry_virtualenv)
}

prompt_geometry_render() {
  if [ $? -eq 0 ] ; then
    PROMPT_SYMBOL=$GEOMETRY_SYMBOL_PROMPT
  else
    PROMPT_SYMBOL=$GEOMETRY_SYMBOL_EXIT_VALUE
  fi

  PROMPT="$GEOMETRY_PROMPT_PREFIX %${#PROMPT_SYMBOL}{%(?.$GEOMETRY_PROMPT.$GEOMETRY_EXIT_VALUE)%} %F{$GEOMETRY_COLOR_DIR}%3~%f "

  PROMPT2=" $GEOMETRY_SYMBOL_RPROMPT "

  if ! $PROMPT_GEOMETRY_GIT_ASYNC; then
      RPROMPT="$(prompt_geometry_render_rprompt)"
  else
      RPROMPT=""
  fi
}

prompt_geometry_set_command_timestamp() {
  export prompt_geometry_command_timestamp=$EPOCHSECONDS
}

prompt_geometry_clear_timestamp() {
  unset prompt_geometry_command_exec_time
}

GEOMETRY_ASYNC_PROMPT_PROC=0
prompt_geometry_setup_async_prompt() {

    prompt_geometry_precmd() {
        -prompt-geometry-async-function () {
            echo "${(j/::/)$(prompt_geometry_render_rprompt)}" > ${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME}$$
            kill -s USR1 $$
        }

        # kill child if necessary
        if [[ "${GEOMETRY_ASYNC_PROMPT_PROC}" != 0 ]]; then
            kill -s HUP $GEOMETRY_ASYNC_PROMPT_PROC &> /dev/null || :
        fi

        -prompt-geometry-async-function &!
        GEOMETRY_ASYNC_PROMPT_PROC=$!
    }
    add-zsh-hook precmd prompt_geometry_precmd

    TRAPUSR1() {
        # read from temp file
        RPROMPT="$(<${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME}$$)"

        # reset proc number
        GEOMETRY_ASYNC_PROMPT_PROC=0

        # redisplay
        zle && zle reset-prompt
    }
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

  if $PROMPT_GEOMETRY_EXEC_TIME; then
    add-zsh-hook preexec prompt_geometry_set_command_timestamp
    add-zsh-hook precmd prompt_geometry_check_command_exec_time
  fi

  add-zsh-hook precmd prompt_geometry_set_title
  add-zsh-hook precmd prompt_geometry_render

  if $PROMPT_GEOMETRY_EXEC_TIME; then
    add-zsh-hook precmd prompt_geometry_clear_timestamp
  fi

  if $PROMPT_GEOMETRY_GIT_ASYNC; then
     prompt_geometry_setup_async_prompt
  fi
}

prompt_geometry_setup
