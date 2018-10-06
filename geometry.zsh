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

    local joined="${(ps.$GEOMETRY_SEPARATOR.)arr}"

    # Getting the correct symbol width is not as simple as getting the variable length
    # There are zero width characters that should not be accounted for.
    # E.g: characters that change the symbol to bold.
    #
    # See https://github.com/geometry-zsh/geometry/pull/216 for context.
    # Regex used is the one in the adam2 prompt.
    #
    # TODO: We do not account for utf-8 characters which differ in the number of bytes
    # (which we calculate in the symbol_width) and in the number of columns they occupy on screen.
    #
    # See https://github.com/geometry-zsh/geometry/issues/3

    #echo -n $joined$GEOMETRY_SEPARATOR

    #local width="${#${(S%%)joined//(\%([KF1]|)\{*\}|\%[Bbkf])}}"
    #local fullwidth="${(m)#:-joined}"
    #local padwidth=$(( $fullwidth + $fullwidth - $width ))
    #local padded="${(r:$(($padwidth))::${GEOMETRY_SEPARATOR}:)joined}."
    #echo -n $padded
    echo -n $joined
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
    to_bind=(zle-line-init)

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

PROMPT='$(_geometry_wrap GEOMETRY_PROMPT)'
RPROMPT=''

_geometry_bind_widgets
