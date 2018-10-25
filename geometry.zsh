# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

GEOMETRY_ROOT=${0:A:h}
: ${GEOMETRY_SEPARATOR:=" "}

(($+GEOMETRY_PROMPT))  || GEOMETRY_PROMPT=(geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time)

(( $+functions[ansi] )) || ansi() { (($# - 2)) || echo "%F{$1}$2%f" }
for lib (${GEOMETRY_ROOT}/lib/*.zsh) source $lib

_geometry_wrap() { # join outputs of functions
    local -a outputs
    for cmd in ${(P)1}; do
        (( $+functions[$cmd] )) || source ${GEOMETRY_ROOT}/functions/${cmd}.zsh
        out="$(eval "$cmd")"
        (( $status )) || outputs+="$out"
    done

    echo ${(ps.$GEOMETRY_SEPARATOR.)outputs}$GEOMETRY_SEPARATOR
}

# capture status of last output asap
_geometry_capture_status() { GEOMETRY_LAST_STATUS="$status" }
add-zsh-hook precmd _geometry_capture_status

# Show current command in title
_geometry_set_cmd_title() {
  local COMMAND="${2}"
  local CURR_DIR="${PWD##*/}"
  setopt localoptions no_prompt_subst
  print -n '\e]0;'
  print -rn "$COMMAND @ $CURR_DIR"
  print -n '\a'
}
add-zsh-hook preexec _geometry_set_cmd_title

# Prevent command showing on title after ending
_geometry_set_title() {
  print -n '\e]0;'
  print -Pn '%~'
  print -n '\a'
}
add-zsh-hook precmd _geometry_set_title

setopt prompt_subst

PROMPT='$(_geometry_wrap GEOMETRY_PROMPT)'
RPROMPT=''
