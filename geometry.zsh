# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

GEOMETRY_ROOT=${0:A:h}
: ${GEOMETRY_SEPARATOR:=" "}

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg geometry_echo)
(($+GEOMETRY_INFO)) || GEOMETRY_INFO=(geometry_hostname geometry_jobs)

autoload -U add-zsh-hook

for fun in "${GEOMETRY_ROOT}"/functions/geometry_*.zsh; do . $fun; done

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo -n "%F{$1}$2%f"; }

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
geometry::set_title() { print -n "\e]0;${2} @ ${PWD##*/}\a"; }
add-zsh-hook preexec geometry::set_title

# clear title after command ends
geometry::clear_title() { print -n '\e]0;%~\a'; }
add-zsh-hook precmd geometry::clear_title

# join outputs of functions - pwd first
geometry::wrap() {
    GEOMETRY_LAST_STATUS="$status"
    local -a outputs
    local pwd=$1
    setopt localoptions noautopushd; builtin cd -q $pwd
    shift
    for cmd in $@; do output=$($cmd); (( $? )) || outputs+=$output; done
    echo "${(ps.${GEOMETRY_SEPARATOR}.)outputs}"
}

geometry::rprompt::set() {
  read -r -u "$PCFD" RPROMPT
  zle reset-prompt
  exec {PCFD}<&-
}

geometry::rprompt() {
  zle -F ${PCFD}
  exec {PCFD}< <(geometry::wrap $PWD $GEOMETRY_RPROMPT)
  zle -F ${PCFD} geometry::rprompt::set
}

geometry::prompt() {
  PROMPT="$(geometry::wrap $PWD $GEOMETRY_PROMPT)$GEOMETRY_SEPARATOR"
  geometry::rprompt
}

add-zsh-hook precmd geometry::prompt

geometry::info() { # draw info if no command is given
    [[ -n "$BUFFER" ]] && { zle accept-line && return; }
    info="$(geometry::wrap $PWD $GEOMETRY_INFO)"
    echo "${(%)info}" && geometry::prompt
}
zle -N buffer-empty geometry::info
bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty
