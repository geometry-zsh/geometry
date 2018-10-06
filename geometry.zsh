# Geometry
# Based on Avit, Pure, and MNML
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal/

GEOMETRY_ROOT=${0:A:h}
: ${GEOMETRY_SEPARATOR:=" "}

source "${GEOMETRY_ROOT}/lib/async.zsh"
source "${GEOMETRY_ROOT}/lib/time.zsh"
source "${GEOMETRY_ROOT}/lib/color.zsh"
source "${GEOMETRY_ROOT}/lib/title.zsh"

(($+GEOMETRY_PROMPT)) || GEOMETRY_PROMPT=(geometry_status geometry_path)
(($+GEOMETRY_RPROMPT))|| GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg)

function _geometry_source_functions {
  local cmd
  for context in GEOMETRY_PROMPT GEOMETRY_RPROMPT; do
    for cmd in ${(P)context}; do
      (( $+functions[$cmd] )) && return
      source ${GEOMETRY_ROOT}/functions/${cmd}.zsh
    done
  done
}

# join outputs of components
function _geometry_wrap {
    local -a arr
    arr=()
    local cmd_out=""
    local cmd
    for cmd in ${(P)1}; do
        cmd_out="$(eval "$cmd")"
        if [ -n "$cmd_out" ]; then
            arr+="$cmd_out"
        fi
    done

    echo -n "${(j:${GEOMETRY_SEPARATOR}:e)arr}"
}

# capture exit status and reset prompt
function _geometry_zle-line-init {
    GEOMETRY_LAST_ERROR="$?" # Capture this ASAP
    zle reset-prompt
}

# properly bind widgets
# see: https://github.com/zsh-users/zsh-syntax-highlighting/blob/1f1e629290773bd6f9673f364303219d6da11129/zsh-syntax-highlighting.zsh#L292-L356
function _geometry_bind_widgets() {
    zmodload zsh/zleparameter

    local -a to_bind
    to_bind=(zle-line-init zle-keymap-select buffer-empty)

    typeset -F SECONDS
    local zle_wprefix=s$SECONDS-r$RANDOM

    local cur_widget
    for cur_widget in $to_bind; do
        case "${widgets[$cur_widget]:-""}" in
            user:_geometry_*);;
            user:*)
                zle -N $zle_wprefix-$cur_widget ${widgets[$cur_widget]#*:}
                eval "_geometry_ww_${(q)zle_wprefix}-${(q)cur_widget}() { _geometry_${(q)cur_widget}; zle ${(q)zle_wprefix}-${(q)cur_widget} }"
                zle -N $cur_widget _geometry_ww_$zle_wprefix-$cur_widget
                ;;
            *)
                zle -N $cur_widget _geometry_$cur_widget
                ;;
        esac
    done
}

# Setup
autoload -U colors && colors
setopt prompt_subst

_geometry_source_functions
_geometry_async_setup

PROMPT='$(_geometry_wrap GEOMETRY_PROMPT) '
RPROMPT=''

_geometry_bind_widgets
