# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

typeset -gA GEOMETRY; GEOMETRY[ROOT]=${0:A:h}

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg geometry_echo)
(($+GEOMETRY_INFO)) || GEOMETRY_INFO=()

autoload -U add-zsh-hook

function { local fun; for fun ("${GEOMETRY[ROOT]}"/functions/*) . $fun }

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo -n "%F{$1}$2%f"; }

# Takes number of seconds and formats it for humans
# from https://github.com/sindresorhus/pretty-time-zsh
geometry::time() {
  local seconds detailed color
  local d h m s
  local -a human=()
  seconds=$1
  detailed=$2
  d=$(( seconds / 60 / 60 / 24 ))
  h=$(( seconds / 60 / 60 % 24 ))
  m=$(( seconds / 60 % 60 ))
  s=$(( seconds % 60 ))

  (( d > 0 )) && human+="${d}d" && : ${color:=${GEOMETRY_TIME_COLOR_LONG:-red}}
  (( h > 0 )) && human+="${h}h" && : ${color:=${GEOMETRY_TIME_COLOR_NEUTRAL:-default}}
  (( m > 0 )) && human+="${m}m"
  (( s > 0 )) && human+="${s}s" && : ${color:=${GEOMETRY_TIME_COLOR_SHORT:-green}}

  ${2:-false} && ansi $color ${(j: :)human} || ansi $color $human[1]
}

# Generate a color based on hostname.
geometry::hostcolor() {
  if (( ${+GEOMETRY_HOST_COLOR} )); then
    echo ${GEOMETRY_HOST_COLOR}
    return
  fi

  if (( ${+GEOMETRY_HOST_COLORS} )); then
    local colors=(${GEOMETRY_HOST_COLORS})
  else
    local colors=({1..9})
    (($(echotc Co) == 256)) && colors+=({17..230})
  fi

  local sum=0; for c in ${(s::)^HOST}; do ((sum += $(print -f '%d' "'$c"))); done
  local index="$(($sum % ${#colors}))"

  [[ "$index" -eq 0 ]] && index = 1

  echo ${colors[${index}]}
}

# set title to COMMAND @ CURRENT_DIRECTORY
geometry::set_title() { print -n "\e]0;${2} @ ${PWD##*/}\a"; }
add-zsh-hook preexec geometry::set_title

# clear title after command ends
geometry::clear_title() { print -n '\e]0;%~\a'; }
add-zsh-hook precmd geometry::clear_title

# join outputs of functions - pwd first
geometry::wrap() {
  setopt localoptions noautopushd; builtin cd -q $1
  local -a outputs
  local cmd output
  shift
  for cmd in $@; do output=$($cmd); ( (( $? )) || [[ -z "${output// }" ]] ) || outputs+=$output; done

  echo "${(ej.${GEOMETRY_SEPARATOR:- }.)outputs}"
}

geometry::rprompt::set() {
  if [[ -z "$2" || "$2" == "hup" ]]; then
    read -r -u "$GEOMETRY_ASYNC_FD" RPROMPT
    zle reset-prompt
    exec {1}<&-
  fi
  zle -F "$1"
}

geometry::rprompt() {
  typeset -g GEOMETRY_ASYNC_FD=
  exec {GEOMETRY_ASYNC_FD}< <(geometry::wrap $PWD $GEOMETRY_RPROMPT)
  zle -F "$GEOMETRY_ASYNC_FD" geometry::rprompt::set
}

geometry::prompt() {
  GEOMETRY[LAST_STATUS]="$status"
  PROMPT=" $(geometry::wrap $PWD $GEOMETRY_PROMPT) "
  geometry::rprompt
}

add-zsh-hook precmd geometry::prompt

geometry::info() { # draw info if no command is given
    [[ -n "$BUFFER" ]] && { zle accept-line && return; }
    echo ${(%):-$(geometry::wrap $PWD $GEOMETRY_INFO)}
    geometry::prompt
}
zle -N buffer-empty geometry::info
bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty
