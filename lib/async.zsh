source $GEOMETRY_ROOT/lib/zsh-async/async.zsh

-geometry-async-redraw() {
    # kill any ongoing async_function
    if [[ "${GEOMETRY_ASYNC_PROC_ID}" != 0 ]]; then
        kill -- -$(ps -o pgid= $GEOMETRY_ASYNC_PROC_ID | grep -o '[0-9]*') &> /dev/null || :
    fi

    RPROMPT="${(j/::/)$(prompt_geometry_render_rprompt)}"

    # redisplay
    zle && zle reset-prompt
}

-geometry_async_job() {
  async_job rprompt_worker -geometry-async-redraw
}

# Hooks precmd to run `-geometry_async_function` and hooks
# `USR1` signal to comunicate with it
geometry_async_setup() {
    async
    async_start_worker rprompt_worker -u -n
    add-zsh-hook precmd -geometry_async_job
}
