# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

builtin typeset -gA GEOMETRY

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_echo geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_git geometry_hg geometry_jj geometry_echo)
(($+GEOMETRY_INFO)) || GEOMETRY_INFO=()
(($+GEOMETRY_TITLE)) || GEOMETRY_TITLE=(geometry_path)
(($+GEOMETRY_COMMAND_TITLE)) || GEOMETRY_COMMAND_TITLE=(geometry_last_command geometry_hostname)

builtin autoload -U add-zsh-hook

fpath+=("${0:A:h}"/functions)
autoload -Uz \
  geometry_last_command \
  geometry_docker_machine \
  geometry_echo \
  geometry_exitcode \
  geometry_git \
  geometry_hg \
  geometry_hostname \
  geometry_jj \
  geometry_jobs \
  geometry_kube \
  geometry_newline \
  geometry_node \
  geometry_npm_package_version \
  geometry_path \
  geometry_ruby \
  geometry_rust_version \
  geometry_rustup \
  geometry_status \
  geometry_virtualenv

(( $+functions[ansi] )) || ansi() { (($# - 2)) || builtin echo -n "%F{$1}$2%f"; }
(( $+functions[deansi] )) || deansi() { (($# - 1)) || builtin echo -n "$(echo "$1" | sed s/$(builtin echo "\033")\\\[\[0-9\]\\\{1,2\\\}m//g)"; }

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

  ${detailed:-false} && ansi $color ${(j: :)human} || ansi $color $human[1]
}

# Generate a color based on hostname.
geometry::hostcolor() {
  if (( ${+GEOMETRY_HOST_COLOR} )); then
    builtin echo ${GEOMETRY_HOST_COLOR}
    builtin return
  fi

  if (( ${+GEOMETRY_HOST_COLORS} )); then
    local colors=(${GEOMETRY_HOST_COLORS})
  else
    local colors=({1..9})
    (($(echotc Co) == 256)) && colors+=({17..230})
  fi

  local sum=0; for c in ${(s::)^HOST}; do ((sum += $(builtin print -f '%d' "'$c"))); done
  local index="$(($sum % ${#colors}))"

  [[ "$index" -eq 0 ]] && index = 1

  builtin echo ${colors[${index}]}
}

# set cmd title (while command is running)
geometry::set_cmdtitle() {
  # Make command title available for optional consumption by geometry_cmd
  GEOMETRY_LAST_COMMAND=$2
  local ansiCmdTitle=$(builtin print -P $(geometry::wrap $PWD $GEOMETRY_COMMAND_TITLE))
  local cmdTitle=$(deansi "$ansiCmdTitle")

  builtin echo -ne "\e]1;$cmdTitle\a"
}
add-zsh-hook preexec geometry::set_cmdtitle

# set ordinary title (after command has completed)
geometry::set_title() {
  local ansiTitle=$(print -P $(geometry::wrap $PWD $GEOMETRY_TITLE))
  local title=$(deansi "$ansiTitle")

  builtin echo -ne "\e]1;$title\a"
}
add-zsh-hook precmd geometry::set_title

# join outputs of functions - pwd first
geometry::wrap() {
  setopt localoptions noautopushd; builtin cd -q $1
  local -a outputs
  local cmd output
  builtin shift
  for cmd in $@; do output=$($cmd); ( (( $? )) || [[ -z "${output// }" ]] ) || outputs+=$output; done

  builtin echo "${(ej.${GEOMETRY_SEPARATOR:- }.)outputs}"
}

geometry::rprompt::set() {
  if [[ -z "$2" || "$2" == "hup" ]]; then
    read -r -u "$GEOMETRY_ASYNC_FD" RPROMPT
    builtin zle reset-prompt
    exec {1}<&-
  fi
  builtin zle -F "$1"
}

geometry::rprompt() {
  builtin typeset -g GEOMETRY_ASYNC_FD=
  RPROMPT=
  exec {GEOMETRY_ASYNC_FD}< <(geometry::wrap $PWD $GEOMETRY_RPROMPT)
  builtin zle -F "$GEOMETRY_ASYNC_FD" geometry::rprompt::set
}

geometry::prompt() {
  export GEOMETRY_STATUS=$status
  PROMPT=" $(geometry::wrap $PWD $GEOMETRY_PROMPT) "
}

add-zsh-hook precmd geometry::prompt
add-zsh-hook precmd geometry::rprompt

geometry::info() { # draw info if no command is given
    ([[ -n "$BUFFER" ]] || [[ -z "$GEOMETRY_INFO" ]]) && zle accept-line && return
    zle -M "${(%):-$(geometry::wrap $PWD $GEOMETRY_INFO)}"
}
builtin zle -N buffer-empty geometry::info
builtin bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty
