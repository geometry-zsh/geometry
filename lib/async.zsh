source $GEOMETRY_ROOT/lib/zsh-async/async.zsh 2> /dev/null

# Callback handler to properly render RPROMPT with calculated output
-geometry-async-callback() {
    local job="$1" code="$2" output="$3" exec_time="$4" stderr="$5"
    RPROMPT="${(j/::/)output}"
    zle && zle reset-prompt

    # Explicitely stop async worker
    async_stop_worker geometry_async_worker
}

# Wrapper to call rprompt renderer, needed to set up workers status
-geometry-async-prompt() {
    # In order to work with zsh-async we need to set workers in
    # the proper directory.
    cd -q $1 > /dev/null
    geometry_plugin_render secondary
}

# Flushed currently running async jobs and queues a new one
# See https://github.com/mafredri/zsh-async#async_flush_jobs-worker_name
-geometry-async-job() {
    # See https://github.com/mafredri/zsh-async#async_start_worker-worker_name--u--n--p-pid
    async_start_worker geometry_async_worker -u -n # unique, notify through SIGWINCH
    async_register_callback geometry_async_worker -geometry-async-callback

    async_flush_jobs geometry_async_worker 
    async_job geometry_async_worker -geometry-async-prompt $PWD
}

# Initialize zsh-async and creates a worker
geometry_async_setup() {
    # Workaround for missing zsh-async lib
    if (( ! $+functions[async_init] )); then
      builtin pushd -q $GEOMETRY_ROOT > /dev/null
      command git submodule update --init > /dev/null
      builtin popd -q > /dev/null
      source $GEOMETRY_ROOT/lib/zsh-async/async.zsh 2> /dev/null || { echo "Error: Could not load zsh-async library." >&2; return 1 }
    fi

    async_init

    # Submit a new job every precmd
    add-zsh-hook precmd -geometry-async-job
}
