# geometry_virtualenv - show the current `virtualenv` or `conda` environment

function geometry_virtualenv {
    test  -n "${VIRTUAL_ENV}${CONDA_PREFIX}" || return

    DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}

    : ${GEOMETRY_VIRTUALENV_COLOR:=$DEFAULT_COLOR}
    : ${GEOMETRY_VIRTUALENV_CONDA_COLOR:=$DEFAULT_COLOR}
    : ${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:=:}

    local environment_str=""

    # Add virtualenv name if active
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        local virtualenv_ref=$(basename $VIRTUAL_ENV)
        environment_str="$(color $GEOMETRY_VIRTUALENV_COLOR ${virtualenv_ref})"
    fi

    # Add separator if both active
    if [[ -n "${VIRTUAL_ENV}" && -n "${CONDA_PREFIX}" ]]; then
        environment_str="${environment_str}${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR}"
    fi

    # Add conda environment name if active
    if [[ -n "${CONDA_PREFIX}" ]]; then
        local conda_ref="$(basename $CONDA_PREFIX)"
        environment_str="${environment_str}$(color $GEOMETRY_VIRUALENV_CONDA_COLOR ${conda_ref})"
    fi

    echo -n "${environment_str}"
}
