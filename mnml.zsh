# mnml - simple customizable prompt based on mnml, avit, pure, and minimal
#
# mnml: https://github.com/mnml-zsh/mnml
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# minimal: https://github.com/subnixr/minimal

MNML_ROOT=${0:A:h}
: ${MNML_SEPARATOR:=" "}

(($+MNML_PROMPT)) || MNML_PROMPT=(mnml_echo mnml_status mnml_path)
(($+MNML_RPROMPT)) || MNML_RPROMPT=(mnml_exec_time mnml_git mnml_hg mnml_echo)
(($+MNML_INFO)) || MNML_INFO=(mnml_hostname mnml_jobs)

autoload -U add-zsh-hook

for fun in "${MNML_ROOT}"/functions/mnml_*.zsh; do . $fun; done

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo -n "%F{$1}$2%f"; }

: ${MNML_TIME_COLOR_SHORT:=green}
: ${MNML_TIME_COLOR_NEUTRAL:=white}
: ${MNML_TIME_COLOR_LONG:=red}

# Takes number of seconds and formats it for humans
# from https://github.com/sindresorhus/pretty-time-zsh
mnml::time() {
  local total_seconds=$1
  local detailed=${2:-false}
  local days=$(( total_seconds / 60 / 60 / 24 ))
  local hours=$(( total_seconds / 60 / 60 % 24 ))
  local minutes=$(( total_seconds / 60 % 60 ))
  local seconds=$(( total_seconds % 60 ))
  local -a human=()
  local color

  (( days > 0 )) && human+="${days}d" && color=$MNML_TIME_COLOR_LONG
  (( hours > 0 )) && human+="${hours}h" && : ${color:=$MNML_TIME_COLOR_NEUTRAL}
  (( minutes > 0 )) && human+="${minutes}m"
  (( seconds > 0 )) && human+="${seconds}s" && : ${color:=$MNML_TIME_COLOR_SHORT}

  $detailed && ansi $color ${(j: :)human} || ansi $color $human[0,1]
}

# set title to COMMAND @ CURRENT_DIRECTORY
mnml::set_title() { print -n "\e]0;${2} @ ${PWD##*/}\a"; }
add-zsh-hook preexec mnml::set_title

# clear title after command ends
mnml::clear_title() { print -n '\e]0;%~\a'; }
add-zsh-hook precmd mnml::clear_title

# join outputs of functions - pwd first
mnml::wrap() {
    MNML_LAST_STATUS="$status"
    local -a outputs
    local pwd=$1
    setopt localoptions noautopushd; builtin cd -q $pwd
    shift
    for cmd in $@; do output=$($cmd); (( $? )) || outputs+=$output; done
    echo "${(ps.${MNML_SEPARATOR}.)outputs}"
}

mnml::rprompt::set() {
  if [[ -z "$2" || "$2" == "hup" ]]; then
    read -r -u "$PCFD" RPROMPT
    zle reset-prompt
    exec {1}<&-
  fi
  zle -F "$1"
}

mnml::rprompt() {
  typeset -g PCFD
  exec {PCFD}< <(mnml::wrap $PWD $MNML_RPROMPT)
  zle -F "$PCFD" mnml::rprompt::set
}

mnml::prompt() {
  PROMPT="$(mnml::wrap $PWD $MNML_PROMPT)$MNML_SEPARATOR"
  mnml::rprompt
}

add-zsh-hook precmd mnml::prompt

mnml::info() { # draw info if no command is given
    [[ -n "$BUFFER" ]] && { zle accept-line && return; }
    info="$(mnml::wrap $PWD $MNML_INFO)"
    echo "${(%)info}" && mnml::prompt
}
zle -N buffer-empty mnml::info
bindkey '^M' buffer-empty
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=buffer-empty
