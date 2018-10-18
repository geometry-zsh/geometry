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

# join outputs of components
function _geometry_wrap {
    local -a outputs
    outputs=()
    local out=""
    local cmd
    for cmd in ${(P)1}; do
        (( $+functions[$cmd] )) || source ${GEOMETRY_ROOT}/functions/${cmd}.zsh
        out="$(eval "$cmd")"
        (( $status )) || outputs+="$out"
    done

    echo -n ${(ps.$GEOMETRY_SEPARATOR.)outputs}$GEOMETRY_SEPARATOR
}

function _geometry_capture_status { GEOMETRY_LAST_STATUS="$status" }

add-zsh-hook preexec _geometry_set_cmd_title
add-zsh-hook precmd _geometry_capture_status
add-zsh-hook precmd _geometry_set_title

autoload -U colors && colors
setopt prompt_subst

_geometry_async_setup

PROMPT='$(_geometry_wrap GEOMETRY_PROMPT)'
RPROMPT=''
