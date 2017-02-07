# Misc configurations
typeset -g GEOMETRY_ASYNC_TMP_PATH=${GEOMETRY_ASYNC_TMP_PATH:-/tmp}
typeset -g GEOMETRY_ASYNC_TMP_FILENAME_PREFIX='.geometry-rprompt-info-'
typeset -g GEOMETRY_ASYNC_TMP_FULL_PATH="$GEOMETRY_ASYNC_TMP_PATH/$GEOMETRY_ASYNC_TMP_FILENAME_PREFIX"
typeset -g GEOMETRY_ASYNC_PROC_ID=0

# Renders rprompt and puts result into `${GEOMETRY_ASYNC_TMP_FULL_PATH}$$`
# then signals `USR1`
-geometry_async_function() {
    echo "${(j/::/)$(prompt_geometry_render_rprompt)}" > ${GEOMETRY_ASYNC_TMP_FULL_PATH}$$
    kill -s USR1 $$
}

# Launches `-geometry_async_function` keeping track of PID
# and killing stalled processes if necessary
-geometry_async_precmd() {
    # kill any ongoing async_function
    if [[ "${GEOMETRY_ASYNC_PROC_ID}" != 0 ]]; then
        kill -- -$(ps -o pgid= $GEOMETRY_ASYNC_PROC_ID | grep -o '[0-9]*') &> /dev/null || :
    fi

    -geometry_async_function &!
    GEOMETRY_ASYNC_PROC_ID=$!
}

# Hooks precmd to run `-geometry_async_function` and hooks
# `USR1` signal to comunicate with it
geometry_async_setup() {
    add-zsh-hook precmd '-geometry_async_precmd'

    (\rm ${GEOMETRY_ASYNC_TMP_FULL_PATH}*) &> /dev/null

    TRAPUSR1() {
        # read from temp file
        RPROMPT="$(<${GEOMETRY_ASYNC_TMP_FULL_PATH}$$)"

        # reset proc number
        GEOMETRY_ASYNC_PROC_ID=0

        # redisplay
        zle && zle reset-prompt
    }
}
# Define how to colorize before the variables
prompt_geometry_colorize() {
  echo "%F{$1}$2%f"
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

# alias prompt_geometry_colorize as -g-color
-g-color() {
  prompt_geometry_colorize "$@"
}
# Choose best version of grep
prompt_geometry_set_grep() {
  (command -v rg >/dev/null 2>&1 && echo "rg") \
  || (command -v ag >/dev/null 2>&1 && echo "ag") \
  || echo "grep"
}

GEOMETRY_GREP=${GREP:-$(prompt_geometry_set_grep)}
# Define default separator for plugins' output
typeset -g GEOMETRY_PLUGIN_SEPARATOR=${GEOMETRY_PLUGIN_SEPARATOR:-" "}

# Define default plugins
typeset -ga GEOMETRY_PROMPT_PLUGINS
if [[ $#GEOMETRY_PROMPT_PLUGINS -eq 0 ]]; then
  GEOMETRY_PROMPT_PLUGINS=(exec_time git hg)
fi

# List of active plugins
typeset -ga _GEOMETRY_PROMPT_PLUGINS

# Set up default plugins
geometry_plugin_setup() {
  for plugin in $GEOMETRY_PROMPT_PLUGINS; do
    #source "$GEOMETRY_ROOT/plugins/$plugin/plugin.zsh"
  done
}

# Registers a plugin
geometry_plugin_register() {
  if [[ $# -eq 0 ]]; then
    echo "Error: Missing argument."
    return 1
  fi

  local plugin=$1
  # Check plugin wasn't registered before
  if [[ ! $_GEOMETRY_PROMPT_PLUGINS[(r)$plugin] == "" ]]; then
    echo "Error: Plugin $plugin already registered."
    return 1
  fi

  # Check plugin has been sourced
  local plugin_setup_function="geometry_prompt_${plugin}_setup"
  if [[ $+functions[$plugin_setup_function] == 0 ]]; then
    echo "Error: Plugin $plugin not available."
    return 1
  fi

  if geometry_prompt_${plugin}_setup; then
    _GEOMETRY_PROMPT_PLUGINS+=$plugin
  fi
}

# Unregisters a given plugin
geometry_plugin_unregister() {
  local plugin=$1
  # Check plugin is registered
  if [[ $_GEOMETRY_PROMPT_PLUGINS[(r)$plugin] == "" ]]; then
    echo "Error: Plugin $plugin not registered."
    return 1
  fi

  if [[ $+functions["geometry_prompt_${plugin}_shutdown"] != 0 ]]; then
    geometry_prompt_${plugin}_shutdown
  fi

  _GEOMETRY_PROMPT_PLUGINS[$_GEOMETRY_PROMPT_PLUGINS[(i)$plugin]]=()
}

# List registered plugins
geometry_plugin_list() {
  echo ${(j:\n:)_GEOMETRY_PROMPT_PLUGINS}
}

# Renders the registered plugins
geometry_plugin_render() {
  local rprompt=""
  local render=""

  for plugin in $_GEOMETRY_PROMPT_PLUGINS; do
    render=$(geometry_prompt_${plugin}_render)
    if [[ -n $render ]]; then
      rprompt+="$render$GEOMETRY_PLUGIN_SEPARATOR"
    fi
  done

  echo "$rprompt"
}
GEOMETRY_COLOR_TIME_SHORT=${GEOMETRY_COLOR_TIME_SHORT:-green}
GEOMETRY_COLOR_TIME_NEUTRAL=${GEOMETRY_COLOR_TIME_NEUTRAL:-white}
GEOMETRY_COLOR_TIME_LONG=${GEOMETRY_COLOR_TIME_LONG:-red}
GEOMETRY_COLOR_NO_TIME=${GEOMETRY_COLOR_NO_TIME:-red}

typeset -g geometry_time_human
typeset -g geometry_time_color

# Format time in short format: 4s, 4h, 1d
-prompt_geometry_time_short_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

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
  
  geometry_time_color=$color
  geometry_time_human=$human
}

# Format time in long format: 1d4h33m51s, 33m51s
-prompt_geometry_time_long_format() {
  local human=""
  local color=""
  local days=$1
  local hours=$2
  local minutes=$3
  local seconds=$4

  (( days > 0 )) && human+="${days}d " && color=$GEOMETRY_COLOR_TIME_LONG
  (( hours > 0 )) && human+="${hours}h " && color=${color:-$GEOMETRY_COLOR_TIME_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m "
  human+="${seconds}s" && color=${color:-$GEOMETRY_COLOR_TIME_SHORT}

  geometry_time_color=$color
  geometry_time_human=$human
}

# from https://github.com/sindresorhus/pretty-time-zsh
prompt_geometry_seconds_to_human_time() {
  local total_seconds=$1
  local long_format=$2

  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))

  # It looks redundant but it seems it's not
  if [[ $long_format == true ]]; then
    -prompt_geometry_time_long_format $days $hours $minutes $seconds
  else
    -prompt_geometry_time_short_format $days $hours $minutes $seconds
  fi

  echo "$(prompt_geometry_colorize $geometry_time_color $geometry_time_human)"
}
# Color definitions
GEOMETRY_COLOR_DOCKER_MACHINE=${GEOMETRY_COLOR_DOCKER_MACHINE:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_DOCKER_MACHINE=${GEOMETRY_SYMBOL_DOCKER_MACHINE:-"⚓"}

geometry_prompt_docker_machine_setup() {}

geometry_prompt_docker_machine_render() {
    if test ! -z $DOCKER_MACHINE_NAME; then
        ref=$DOCKER_MACHINE_NAME || return
        echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_DOCKER_MACHINE "(${GEOMETRY_SYMBOL_DOCKER_MACHINE} ${ref})")"
    fi
}

# Self-register plugin
geometry_plugin_register docker_machine
# Load zsh/datetime module to be able to access `$EPOCHSECONDS`
zmodload zsh/datetime || return

# Flags
PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME=${PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME:-5}

typeset -g prompt_geometry_command_timestamp
typeset -g prompt_geometry_command_exec_time

# Stores (into prompt_geometry_command_exec_time) the exec time of the last command if set threshold was exceeded
prompt_geometry_check_command_exec_time() {
  integer elapsed
  # Default value for exec_time is an empty string (ie, it won't be rendered),
  # if we don't clear this up it may be rendered each time
  prompt_geometry_command_exec_time=

  # Check if elapsed time is above the configured threshold
  (( elapsed = EPOCHSECONDS - ${prompt_geometry_command_timestamp:-$EPOCHSECONDS} ))
  if (( elapsed > $PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME )); then
    prompt_geometry_command_exec_time="$(prompt_geometry_seconds_to_human_time $elapsed)"
  fi

  # Clear timestamp after we're done calculating exec_time
  prompt_geometry_command_timestamp=
}

prompt_geometry_set_command_timestamp() {
  prompt_geometry_command_timestamp=$EPOCHSECONDS
}

geometry_prompt_exec_time_setup() {
  # Begin to track the EPOCHSECONDS since this command is executed
  add-zsh-hook preexec prompt_geometry_set_command_timestamp
  # Check if we need to display execution time
  add-zsh-hook precmd prompt_geometry_check_command_exec_time

  return true
}

geometry_prompt_exec_time_render() {
  echo "$prompt_geometry_command_exec_time"
}

# Self-register plugin
geometry_plugin_register exec_time
# Color definitions
GEOMETRY_COLOR_GIT_DIRTY=${GEOMETRY_COLOR_GIT_DIRTY:-red}
GEOMETRY_COLOR_GIT_CLEAN=${GEOMETRY_COLOR_GIT_CLEAN:-green}
GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED=${GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED:-red}
GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED=${GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED:-green}
GEOMETRY_COLOR_GIT_BRANCH=${GEOMETRY_COLOR_GIT_BRANCH:-242}

# Symbol definitions
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

# Flags
PROMPT_GEOMETRY_GIT_CONFLICTS=${PROMPT_GEOMETRY_GIT_CONFLICTS:-false}
PROMPT_GEOMETRY_GIT_TIME=${PROMPT_GEOMETRY_GIT_TIME:-true}
PROMPT_GEOMETRY_GIT_TIME_LONG_FORMAT=${PROMPT_GEOMETRY_GIT_TIME_LONG_FORMAT:-false}
PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY=${PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY:-true}

# Misc configurations
GEOMETRY_GIT_NO_COMMITS_MESSAGE=${GEOMETRY_GIT_NO_COMMITS_MESSAGE:-"no commits"}
GEOMETRY_GIT_SEPARATOR=${GEOMETRY_GIT_SEPARATOR:-"::"}

prompt_geometry_git_time_since_commit() {
  # Defaults to "", which would hide the git_time_since_commit block
  local git_time_since_commit=""

  # Get the last commit.
  local last_commit=$(git log -1 --pretty=format:'%at' 2> /dev/null)
  if [[ -n $last_commit ]]; then
      now=$(date +%s)
      seconds_since_last_commit=$((now - last_commit))
      git_time_since_commit=$(prompt_geometry_seconds_to_human_time $seconds_since_last_commit $PROMPT_GEOMETRY_GIT_TIME_LONG_FORMAT)
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

prompt_geometry_git_status() {
  if test -z "$(git status --porcelain --ignore-submodules HEAD)"; then
    if test -z "$(git ls-files --others --modified --exclude-standard)"; then
      echo $GEOMETRY_GIT_CLEAN
    else
      echo $GEOMETRY_GIT_DIRTY
    fi
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
  local render=""
  local git_rebase="$(prompt_geometry_git_rebase_check)"
  local git_remote="$(prompt_geometry_git_remote_check)"

  if [[ -n $git_rebase ]]; then
    render+="$git_rebase"
  fi

  if [[ -n $git_rebase && -n $git_remote ]]; then
    render+=" "
  fi

  if [[ -n $git_remote ]]; then
    render+="$git_remote"
  fi

  echo -n $render
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

geometry_prompt_git_setup() {
}

geometry_prompt_git_render() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if $PROMPT_GEOMETRY_GIT_CONFLICTS ; then
      conflicts="$(prompt_geometry_git_conflicts)"
    fi

    if $PROMPT_GEOMETRY_GIT_TIME; then
      local git_time_since_commit=$(prompt_geometry_git_time_since_commit)
      if [[ -n $git_time_since_commit ]]; then
          time=" $git_time_since_commit $GEOMETRY_GIT_SEPARATOR"
      fi
    fi

    local render="$(prompt_geometry_git_symbol)"

    if [[ -n $render ]]; then
      render+=" "
    fi

    render+="$(prompt_geometry_git_branch) ${conflicts}${GEOMETRY_GIT_SEPARATOR}${time} $(prompt_geometry_git_status)"

    echo -n $render
  fi
}

# Self-register plugin
geometry_plugin_register git
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

# Color definitions
GEOMETRY_COLOR_NODE_NPM_VERSION=${GEOMETRY_COLOR_NODE_NPM_VERSION:-black}

# Symbol definitions
GEOMETRY_SYMBOL_NODE_NPM_VERSION=${GEOMETRY_SYMBOL_NODE_NPM_VERSION:-"⬡"}
GEOMETRY_NODE_NPM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_NODE_NPM_VERSION $GEOMETRY_SYMBOL_NODE_NPM_VERSION) 

geometry_prompt_node_setup() {}

geometry_prompt_node_render() {
    if (( $+commands[node] )); then
        GEOMETRY_NODE_VERSION="$(node -v 2> /dev/null)"
        GEOMETRY_NPM_VERSION="$(npm --version 2> /dev/null)" 
        echo "$GEOMETRY_NODE_NPM_VERSION $GEOMETRY_NODE_VERSION ($GEOMETRY_NPM_VERSION)"
    fi
}

geometry_plugin_register node
# Color definitions
GEOMETRY_COLOR_RUBY_RVM_VERSION=${GEOMETRY_COLOR_PROMPT:-white}

GEOMETRY_RUBY_RVM_SHOW_GEMSET=${GEOMETRY_RUBY_RVM_SHOW_GEMSET:-true}

# Symbol definitions
GEOMETRY_SYMBOL_RUBY_RVM_VERSION=${GEOMETRY_SYMBOL_RUBY_RVM_VERSION:-"◆"}
GEOMETRY_RUBY_RVM_VERSION=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUBY_RVM_VERSION $GEOMETRY_SYMBOL_RUBY_RVM_VERSION) 

prompt_geometry_get_full_ruby_version() {
  if (( $+commands[ruby] )); then
      GEOMETRY_RUBY_VERSION_FULL="$(ruby -v)"
  fi
}

prompt_geometry_ruby_version() {
  [[ $GEOMETRY_RUBY_VERSION_FULL =~ 'ruby ([0-9a-zA-Z.]+)' ]]
  GEOMETRY_RUBY_VERSION=$match[1]
}

prompt_geometry_get_full_rvm_version() {
  if (( $+commands[rvm] )); then
      GEOMETRY_RVM_VERSION_FULL="$(rvm -v)"
  fi
}

prompt_geometry_rvm_version() {
  [[ $GEOMETRY_RVM_VERSION_FULL =~ 'rvm ([0-9a-zA-Z.]+)'  ]]
  GEOMETRY_RVM_VERSION=$match[1]
}

geometry_prompt_ruby_setup() {}

prompt_geometry_current_rvm_gemset_name() {
  if $GEOMETRY_RUBY_RVM_SHOW_GEMSET; then
      local cur_dir=$(pwd)
      local gemset_name=$(rvm current)
      [[ $gemset_name =~ 'ruby-[0-9.]+@?(.*)' ]]

      # If no name present, then it's the default gemset
      if [[ -z $match[1] ]]; then
          echo "default"
      else
          echo $match[1]
      fi
  fi
}

geometry_prompt_ruby_render() {
  if (( ! $+commands[ruby] )); then
      return "";
  fi

  prompt_geometry_get_full_ruby_version
  prompt_geometry_ruby_version

  local result="$GEOMETRY_RUBY_RVM_VERSION $GEOMETRY_RUBY_VERSION"

  if (( $+commands[rvm] )); then
      prompt_geometry_get_full_rvm_version
      prompt_geometry_rvm_version

      result=$result" ($GEOMETRY_RVM_VERSION"

      # Add current gemset name
      local rvm_gemset_name=$( prompt_geometry_current_rvm_gemset_name )
      if [[ ! -z $rvm_gemset_name ]]; then
          result=$result" $rvm_gemset_name"
      fi

      result=$result")"
  fi

  echo $result
}

geometry_plugin_register ruby
# Color definitions
GEOMETRY_COLOR_RUSTUP_stable=${GEOMETRY_COLOR_RUSTUP_STABLE:-green}
GEOMETRY_COLOR_RUSTUP_beta=${GEOMETRY_COLOR_RUSTUP_BETA:-yellow}
GEOMETRY_COLOR_RUSTUP_nightly=${GEOMETRY_COLOR_RUSTUP_NIGHTLY:-red}

# Symbol definitions
GEOMETRY_SYMBOL_RUSTUP=${GEOMETRY_SYMBOL_RUSTUP:-"⚙"}
GEOMETRY_SYMBOL_RUSTUP_SEPARATOR=${GEOMETRY_SYMBOL_RUSTUP_SEPARATOR:-"$GEOMETRY_GIT_SEPARATOR"}

geometry_prompt_rustup_setup() {}

geometry_prompt_rustup_render() {
    if (( $+commands[rustup_prompt_helper] )); then
        git rev-parse --git-dir > /dev/null 2>&1 || GEOMETRY_SYMBOL_RUSTUP_SEPARATOR=""
        GEOMETRY_RUSTUP_TOOLCHAIN="$(rustup_prompt_helper 2> /dev/null)"
        GEOMETRY_COLOR_RUSTUP=${(e)GEOMETRY_RUSTUP_TOOLCHAIN:+\$GEOMETRY_COLOR_RUSTUP_${GEOMETRY_RUSTUP_TOOLCHAIN}}
        GEOMETRY_RUSTUP=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUSTUP $GEOMETRY_SYMBOL_RUSTUP)
        echo "$GEOMETRY_SYMBOL_RUSTUP_SEPARATOR $GEOMETRY_RUSTUP"
    fi
}

geometry_plugin_register rustup
# Color definitions
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_PROMPT:-green}

geometry_prompt_virtualenv_setup() {}

geometry_prompt_virtualenv_render() {
  local ref
  if test ! -z $VIRTUAL_ENV; then
    ref=$(basename $VIRTUAL_ENV) || return
    echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV "(${ref})")"
  fi
}

# Self-register plugin
geometry_plugin_register virtualenv
# Geometry
# Based on Avit and Pure
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
GEOMETRY_ROOT=${0:A:h}
#source "$GEOMETRY_ROOT/lib/async.zsh"
#source "$GEOMETRY_ROOT/lib/plugin.zsh"
#source "$GEOMETRY_ROOT/lib/time.zsh"
#source "$GEOMETRY_ROOT/lib/color.zsh"
#source "$GEOMETRY_ROOT/lib/grep.zsh"

# Color definitions
GEOMETRY_COLOR_EXIT_VALUE=${GEOMETRY_COLOR_EXIT_VALUE:-magenta}
GEOMETRY_COLOR_PROMPT=${GEOMETRY_COLOR_PROMPT:-white}
GEOMETRY_COLOR_ROOT=${GEOMETRY_COLOR_ROOT:-red}
GEOMETRY_COLOR_DIR=${GEOMETRY_COLOR_DIR:-blue}

# Symbol definitions
GEOMETRY_SYMBOL_PROMPT=${GEOMETRY_SYMBOL_PROMPT:-"▲"}
GEOMETRY_SYMBOL_RPROMPT=${GEOMETRY_SYMBOL_RPROMPT:-"◇"}
GEOMETRY_SYMBOL_EXIT_VALUE=${GEOMETRY_SYMBOL_EXIT_VALUE:-"△"}
GEOMETRY_SYMBOL_ROOT=${GEOMETRY_SYMBOL_ROOT:-"▲"}

# Combine color and symbols
GEOMETRY_EXIT_VALUE=$(prompt_geometry_colorize $GEOMETRY_COLOR_EXIT_VALUE $GEOMETRY_SYMBOL_EXIT_VALUE)
GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)

# Flags
PROMPT_GEOMETRY_COLORIZE_SYMBOL=${PROMPT_GEOMETRY_COLORIZE_SYMBOL:-false}
PROMPT_GEOMETRY_COLORIZE_ROOT=${PROMPT_GEOMETRY_COLORIZE_ROOT:-false}
PROMPT_GEOMETRY_SHOW_RPROMPT=${PROMPT_GEOMETRY_SHOW_RPROMPT:-true}
PROMPT_GEOMETRY_RPROMPT_ASYNC=${PROMPT_GEOMETRY_RPROMPT_ASYNC:-true}
PROMPT_GEOMETRY_ENABLE_PLUGINS=${PROMPT_GEOMETRY_ENABLE_PLUGINS:-true}

# Misc configurations
GEOMETRY_PROMPT_PREFIX=${GEOMETRY_PROMPT_PREFIX:-$'\n'}
GEOMETRY_PROMPT_SUFFIX=${GEOMETRY_PROMPT_SUFFIX:-''}

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
    # Renders all registered plugins
    geometry_plugin_render
}

prompt_geometry_render() {
  if [ $? -eq 0 ] ; then
    PROMPT_SYMBOL=$GEOMETRY_SYMBOL_PROMPT
  else
    PROMPT_SYMBOL=$GEOMETRY_SYMBOL_EXIT_VALUE
  fi

  PROMPT="$GEOMETRY_PROMPT_PREFIX %${#PROMPT_SYMBOL}{%(?.$GEOMETRY_PROMPT.$GEOMETRY_EXIT_VALUE)%} %F{$GEOMETRY_COLOR_DIR}%3~%f $GEOMETRY_PROMPT_SUFFIX"

  PROMPT2=" $GEOMETRY_SYMBOL_RPROMPT "

  if $PROMPT_GEOMETRY_SHOW_RPROMPT; then
    if $PROMPT_GEOMETRY_RPROMPT_ASYNC; then
        # On render we reset rprompt until async process
        # comes with newer git info
        RPROMPT=""
    else
        RPROMPT="$(prompt_geometry_render_rprompt)"
    fi
  fi
}

prompt_geometry_setup() {
  setopt PROMPT_SUBST
  zmodload zsh/datetime
  autoload -U add-zsh-hook
  if $PROMPT_GEOMETRY_ENABLE_PLUGINS; then
      geometry_plugin_setup
  fi

  if $PROMPT_GEOMETRY_COLORIZE_SYMBOL; then
    export GEOMETRY_COLOR_PROMPT=$(prompt_geometry_hash_color $HOST)
    export GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_PROMPT $GEOMETRY_SYMBOL_PROMPT)
  fi

  # TODO make plugin root.zsh
  if $PROMPT_GEOMETRY_COLORIZE_ROOT && [[ $UID == 0 || $EUID == 0 ]]; then
    export GEOMETRY_PROMPT=$(prompt_geometry_colorize $GEOMETRY_COLOR_ROOT $GEOMETRY_SYMBOL_ROOT)
  fi

  add-zsh-hook preexec prompt_geometry_set_cmd_title
  add-zsh-hook precmd prompt_geometry_set_title
  add-zsh-hook precmd prompt_geometry_render

  if $PROMPT_GEOMETRY_SHOW_RPROMPT && $PROMPT_GEOMETRY_RPROMPT_ASYNC; then
     geometry_async_setup
  fi
}

prompt_geometry_setup
