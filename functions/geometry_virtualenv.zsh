# geometry_virtualenv - show the current `virtualenv` or `conda` environment

geometry_virtualenv() {
    [[ -n "${VIRTUAL_ENV}${CONDA_PREFIX}" ]] || return 1

    : ${GEOMETRY_VIRTUALENV_COLOR:=green}
    : ${GEOMETRY_VIRTUALENV_CONDA_COLOR:=green}
    : ${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:=:}

    VENV=${VIRTUAL_ENV:+$(ansi ${GEOMETRY_VIRTUALENV_COLOR} ${VIRTUAL_ENV:t})}
    CNDA=${CONDA_PREFIX:+$(ansi ${GEOMETRY_VIRTUALENV_CONDA_COLOR} ${CONDA_PREFIX:t})}
    echo -n ${(pj.$GEOMETRY_VIRTUALENV_CONDA_SEPARATOR.)$(print "$VENV" "$CNDA")}
}
