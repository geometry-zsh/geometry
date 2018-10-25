# geometry_virtualenv - show the current `virtualenv` or `conda` environment

geometry_virtualenv() {
    [[ -n "${VIRTUAL_ENV}${CONDA_PREFIX}" ]] || { echo -n "" && return }

    DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}

    echo -n ${(pj.${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:=:}.)$(print -r \
      "${VIRTUAL_ENV:+$(ansi ${GEOMETRY_VIRTUALENV_COLOR:=$DEFAULT_COLOR} ${VIRTUAL_ENV:t})}" \
      "${CONDA_PREFIX:+$(ansi ${GEOMETRY_VIRUALENV_CONDA_COLOR:=$DEFAULT_COLOR} ${CONDA_PREFIX:t})}" \
    )}
}
