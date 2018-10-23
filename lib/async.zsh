(($precmd_functions[(I)-geometry-async-job])) && return

# Initialize zsh-async and creates a worker
async=$GEOMETRY_ROOT/lib/zsh-async/async.zsh
(( $+functions[async_init] )) || {
  [[ -f $async ]] || { # checkout zsh-async if not found
    builtin pushd -q $GEOMETRY_ROOT > /dev/null
    command git submodule update --init > /dev/null
    builtin popd -q > /dev/null
  }
  source $async || { >&2 echo "Error: Could not load zsh-async library." && exit -1}
}

# Callback handler
-geometry-async-callback() {
    RPROMPT="${(j/::/)3}" # job=$1 code=$2 output=$3 exec_time=$4 stderr=$5
    zle && zle reset-prompt
    async_stop_worker geometry_async_worker
}

# Wrapper to call rprompt renderer, needed to set up workers status
-geometry-async-prompt() {
    cd -q $1 > /dev/null # zsh-async needs workers to be in the proper directory
    _geometry_wrap GEOMETRY_RPROMPT
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

async_init
add-zsh-hook precmd -geometry-async-job
