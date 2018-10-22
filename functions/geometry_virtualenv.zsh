# geometry_virtualenv - show the current `virtualenv` or `conda` environment

function geometry_virtualenv {
    [[ -n "${VIRTUAL_ENV}${CONDA_PREFIX}" ]] || return

    DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}

    : ${GEOMETRY_VIRTUALENV_COLOR:=$DEFAULT_COLOR}
    : ${GEOMETRY_VIRTUALENV_CONDA_COLOR:=$DEFAULT_COLOR}
    : ${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:=:}

    local environment_str=""

    # Add virtualenv name if active
    [[ -n "${VIRTUAL_ENV}" ]] \
      && environment_str="$(ansi $GEOMETRY_VIRTUALENV_COLOR ${VIRTUAL_ENV:t})"

    # Add separator if both active
    [[ -n "${VIRTUAL_ENV}" && -n "${CONDA_PREFIX}" ]] \
      && environment_str+="${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR}"

    # Add conda environment name if active
    [[ -n "${CONDA_PREFIX}" ]] \
      && environment_str+="$(ansi $GEOMETRY_VIRUALENV_CONDA_COLOR ${CONDA_PREFIX:t})"

    echo "${environment_str}"
}
