# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

GEOMETRY_ROOT=${0:A:h}
: ${GEOMETRY_SEPARATOR:=" "}

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg)
(($+GEOMETRY_INFO)) || GEOMETRY_INFO=(geometry_hostname geometry_jobs)

autoload -U add-zsh-hook

for fun in "${GEOMETRY_ROOT}"/functions/geometry_*.zsh; do . $fun; done

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo -n "%F{$1}$2%f" }

: ${GEOMETRY_TIME_COLOR_SHORT:=green}
: ${GEOMETRY_TIME_COLOR_NEUTRAL:=white}
: ${GEOMETRY_TIME_COLOR_LONG:=red}

# Takes number of seconds and formats it for humans
# from https://github.com/sindresorhus/pretty-time-zsh
geometry::time() {
  local total_seconds=$1
  local detailed=${2:-false}
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))
  local -a human=()
  local color

  (( days > 0 )) && human+="${days}d" && color=$GEOMETRY_TIME_COLOR_LONG
  (( hours > 0 )) && human+="${hours}h" && : ${color:=$GEOMETRY_TIME_COLOR_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m"
  (( seconds > 0 )) && human+="${seconds}s" && : ${color:=$GEOMETRY_TIME_COLOR_SHORT}

  $detailed && ansi $color ${(j: :)human} || ansi $color $human[0,1]
}

# set title to COMMAND @ CURRENT_DIRECTORY
geometry::set_title() { print -Pn '\e]0;${2} @ ${PWD##*/}\a' }
add-zsh-hook preexec geometry::set_title

# clear title after command ends
geometry::clear_title() { print -Pn '\e]0;%~\a' }
add-zsh-hook precmd geometry::clear_title

# join outputs of functions
geometry::wrap() {
    GEOMETRY_LAST_STATUS="$status"
    local -a outputs
    setopt localoptions noautopushd; builtin cd -q "${2:-$PWD}"
    for cmd in ${(P)1}; do outputs+=$($cmd); done
    echo -n "${(ps.${GEOMETRY_SEPARATOR}.)outputs}$GEOMETRY_SEPARATOR"
}

# download and source latest async library if not found
(( $+functions[async_init] )) || {
    [[ -f $GEOMETRY_ROOT/async.zsh ]] || curl -sOL https://raw.githubusercontent.com/mafredri/zsh-async/master/async.zsh
    source $GEOMETRY_ROOT/async.zsh || { >&2 echo "Error: Could not load zsh-async library." && exit -1}
}

geometry::rprompt() {
  RPROMPT="${(j/::/)3}"
  zle && zle reset-prompt
  async_stop_worker geometry
}

geometry::prompt() {
  PROMPT=$(geometry::wrap GEOMETRY_PROMPT)
  async_start_worker geometry -n
  async_register_callback geometry geometry::rprompt
  async_job geometry geometry::wrap GEOMETRY_RPROMPT $PWD
}

add-zsh-hook precmd geometry::prompt

geometry::info() { # draw info if no command is given
    [[ -n "$BUFFER" ]] && { zle accept-line && return }
    info="$(geometry::wrap GEOMETRY_INFO $PWD)"
    echo "${(%)info}" && zle redisplay
}
zle -N buffer-empty geometry::info
bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty

geometry::rprompt
