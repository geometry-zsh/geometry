# Misc configurations
GEOMETRY_ASYNC_PROMPT_TMP_FILENAME=${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME:-/tmp/geometry-prompt-git-info-}

GEOMETRY_ASYNC_PROMPT_PROC=0
prompt_geometry_setup_async_prompt() {

    prompt_geometry_precmd() {
        -prompt-geometry-async-function () {
            echo "${(j/::/)$(prompt_geometry_render_rprompt)}" > ${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME}$$
            kill -s USR1 $$
        }

        # kill child if necessary
        if [[ "${GEOMETRY_ASYNC_PROMPT_PROC}" != 0 ]]; then
            kill -- -$(ps -o pgid= $GEOMETRY_ASYNC_PROMPT_PROC | grep -o '[0-9]*') &> /dev/null || :
        fi

        -prompt-geometry-async-function &!
        GEOMETRY_ASYNC_PROMPT_PROC=$!
    }
    add-zsh-hook precmd prompt_geometry_precmd

    TRAPUSR1() {
        # read from temp file
        RPROMPT="$(<${GEOMETRY_ASYNC_PROMPT_TMP_FILENAME}$$)"

        # reset proc number
        GEOMETRY_ASYNC_PROMPT_PROC=0

        # redisplay
        zle && zle reset-prompt
    }
}