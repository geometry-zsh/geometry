source $GEOMETRY_ROOT/lib/zsh-async/async.zsh

# Callback handler to properly render RPROMPT with calculated output
-geometry-async-callback() {
    local job="$1" code="$2" output="$3" exec_time="$4" stderr="$5"
    RPROMPT="${(j/::/)output}"
    zle && zle reset-prompt
}

# Wrapper to call rprompt renderer, needed to set up workers status
-geometry-async-prompt() {
    # In order to work with zsh-async we need to set workers in
    # the proper directory.
    cd -q $1 > /dev/null
    prompt_geometry_render_rprompt
}

# Flushed currently running async jobs and queues a new one
# See https://github.com/mafredri/zsh-async#async_flush_jobs-worker_name
-geometry-async-job() {
    async_flush_jobs geometry_async_worker 
    async_job geometry_async_worker -geometry-async-prompt $PWD
}

# Initialize zsh-async and creates a worker
geometry_async_setup() {
    async_init
    # See https://github.com/mafredri/zsh-async#async_start_worker-worker_name--u--n--p-pid
    async_start_worker geometry_async_worker -u -n # unique, notify through SIGWINCH
    async_register_callback geometry_async_worker -geometry-async-callback

    # Submit a new job every precmd
    add-zsh-hook precmd -geometry-async-job
}

