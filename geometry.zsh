# Geometry
# Based on Avit, Pure, and MNML
# avit: https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme
# pure: https://github.com/sindresorhus/pure
# mnml: https://github.com/subnixr/minimal/

MNML_ROOT=${0:A:h}
source "${MNML_ROOT}/lib/color.zsh"

MNML_OK_COLOR="${MNML_OK_COLOR:-2}"
MNML_ERR_COLOR="${MNML_ERR_COLOR:-1}"

MNML_USER_CHAR="${MNML_USER_CHAR:-λ}"
MNML_INSERT_CHAR="${MNML_INSERT_CHAR:-›}"
MNML_NORMAL_CHAR="${MNML_NORMAL_CHAR:-·}"

[ "${+MNML_PROMPT}" -eq 0 ] && MNML_PROMPT=(mnml_status)
[ "${+MNML_RPROMPT}" -eq 0 ] && MNML_RPROMPT=(mnml_hostname mnml_path)
#[ "${+MNML_INFOLN}" -eq 0 ] && MNML_INFOLN=(mnml_err mnml_jobs mnml_uhp mnml_files)
#[ "${+MNML_MAGICENTER}" -eq 0 ] && MNML_MAGICENTER=(mnml_me_dirs mnml_me_ls mnml_me_git)

function _mnml_source_plugins { 
  local cmd
  for cmd in ${(P)1}; do
    (( $+commands[$cmd] )) && return
    source ${MNML_ROOT}/commands/${cmd}.zsh
  done
}

# Wrappers & utils
# join outpus of components
function _mnml_wrap {
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

    echo -n "${(j: :)arr}"
}

# expand string as prompt would do
function _mnml_iline {
    echo "${(%)1}"
}

# display magic enter
function _mnml_me {
    local -a output
    output=()
    local cmd_out=""
    local cmd
    for cmd in $MNML_MAGICENTER; do
        cmd_out="$(eval "$cmd")"
        if [ -n "$cmd_out" ]; then
            output+="$cmd_out"
        fi
    done
    echo -n "${(j:\n:)output}" | less -XFR
}

# capture exit status and reset prompt
function _mnml_zle-line-init {
    MNML_LAST_ERR="$?" # I need to capture this ASAP
    zle reset-prompt
}

# redraw prompt on keymap select
function _mnml_zle-keymap-select {
    zle reset-prompt
}

# draw infoline if no command is given
function _mnml_buffer-empty {
    if [ -z "$BUFFER" ]; then
        _mnml_iline "$(_mnml_wrap MNML_INFOLN)"
        _mnml_me
        zle redisplay
    else
        zle accept-line
    fi
}

# properly bind widgets
# see: https://github.com/zsh-users/zsh-syntax-highlighting/blob/1f1e629290773bd6f9673f364303219d6da11129/zsh-syntax-highlighting.zsh#L292-L356
function _mnml_bind_widgets() {
    zmodload zsh/zleparameter

    local -a to_bind
    to_bind=(zle-line-init zle-keymap-select buffer-empty)

    typeset -F SECONDS
    local zle_wprefix=s$SECONDS-r$RANDOM

    local cur_widget
    for cur_widget in $to_bind; do
        case "${widgets[$cur_widget]:-""}" in
            user:_mnml_*);;
            user:*)
                zle -N $zle_wprefix-$cur_widget ${widgets[$cur_widget]#*:}
                eval "_mnml_ww_${(q)zle_wprefix}-${(q)cur_widget}() { _mnml_${(q)cur_widget}; zle ${(q)zle_wprefix}-${(q)cur_widget} }"
                zle -N $cur_widget _mnml_ww_$zle_wprefix-$cur_widget
                ;;
            *)
                zle -N $cur_widget _mnml_$cur_widget
                ;;
        esac
    done
}

# Setup
autoload -U colors && colors
setopt prompt_subst

_mnml_source_plugins MNML_PROMPT
_mnml_source_plugins MNML_RPROMPT

PROMPT='$(_mnml_wrap MNML_PROMPT) '
RPROMPT='$(_mnml_wrap MNML_RPROMPT)'

_mnml_bind_widgets

bindkey -M main  "^M" buffer-empty
bindkey -M vicmd "^M" buffer-empty
