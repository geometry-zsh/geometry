# geometry - simple customizable prompt based on avit, pure, and mnml
#
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal

GEOMETRY_ROOT=${0:A:h}
: ${GEOMETRY_SEPARATOR:=" "}

(($+GEOMETRY_PROMPT))  || GEOMETRY_PROMPT=(geometry_status geometry_path)
(($+GEOMETRY_RPROMPT)) || GEOMETRY_RPROMPT=(geometry_exec_time geometry_git geometry_hg)

(( $+functions[ansi] )) || function ansi { (($# - 2)) || echo "%F{$1}$2%f" }
for lib (${GEOMETRY_ROOT}/lib/*.zsh) source $lib

function _geometry_wrap { # join outputs of functions
    local -a outputs
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

setopt prompt_subst

PROMPT='$(_geometry_wrap GEOMETRY_PROMPT)'
RPROMPT=''
