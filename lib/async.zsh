# Misc configurations
typeset -g GEOMETRY_ASYNC_TMP_PATH=${GEOMETRY_ASYNC_TMP_PATH:-/tmp}
typeset -g GEOMETRY_ASYNC_TMP_FILENAME_PREFIX='.geometry-rprompt-info-'
typeset -g GEOMETRY_ASYNC_TMP_FULL_PATH="$GEOMETRY_ASYNC_TMP_PATH/$GEOMETRY_ASYNC_TMP_FILENAME_PREFIX"
typeset -g GEOMETRY_ASYNC_PROC_ID=0

# Renders rprompt and puts result into `${GEOMETRY_ASYNC_TMP_FULL_PATH}$$`
# then signals `USR1`
-geometry_async_function() {
    echo "${(j/::/)$(prompt_geometry_render_rprompt)}" > ${GEOMETRY_ASYNC_TMP_FULL_PATH}$$
    kill -s USR1 $$
}

# Launches `-geometry_async_function` keeping track of PID
# and killing stalled processes if necessary
-geometry_async_precmd() {
    # kill any ongoing async_function
    if [[ "${GEOMETRY_ASYNC_PROC_ID}" != 0 ]]; then
        kill -- -$(ps -o pgid= $GEOMETRY_ASYNC_PROC_ID | grep -o '[0-9]*') &> /dev/null || :
    fi

    -geometry_async_function &!
    GEOMETRY_ASYNC_PROC_ID=$!
}

# Hooks precmd to run `-geometry_async_function` and hooks
# `USR1` signal to comunicate with it
geometry_async_setup() {
    add-zsh-hook precmd '-geometry_async_precmd'

    (\rm ${GEOMETRY_ASYNC_TMP_FULL_PATH}*) &> /dev/null

    TRAPUSR1() {
        # read from temp file
        RPROMPT="$(<${GEOMETRY_ASYNC_TMP_FULL_PATH}$$)"

        # reset proc number
        GEOMETRY_ASYNC_PROC_ID=0

        # redisplay
        zle && zle reset-prompt
    }
}
