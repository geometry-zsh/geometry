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

# Removes the async temp file when zsh exits
-geometry_async_zshexit() {
    rm -f "${GEOMETRY_ASYNC_TMP_FULL_PATH}$$"
}

# geometry_async_setup adds zsh-hooks into precmd and zshexit, as well as a
# signal trap on SIGUSR1, to support communication of asynchronous updates to
# the running terminal.
geometry_async_setup() {
    add-zsh-hook precmd '-geometry_async_precmd'
    add-zsh-hook zshexit '-geometry_async_zshexit'

    TRAPUSR1() {
        # read from temp file
        RPROMPT="$(<${GEOMETRY_ASYNC_TMP_FULL_PATH}$$)"

        # reset proc number
        GEOMETRY_ASYNC_PROC_ID=0

        # redisplay
        zle && zle reset-prompt
    }
}
