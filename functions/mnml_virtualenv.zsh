# mnml_virtualenv - show the current `virtualenv` or `conda` environment

mnml_virtualenv() {
    [[ -n "${VIRTUAL_ENV}${CONDA_PREFIX}" ]] || return 1

    : ${MNML_VIRTUALENV_COLOR:=green}
    : ${MNML_VIRTUALENV_CONDA_COLOR:=green}
    : ${MNML_VIRTUALENV_CONDA_SEPARATOR:=:}

    VENV=${VIRTUAL_ENV:+$(ansi ${MNML_VIRTUALENV_COLOR} ${VIRTUAL_ENV:t})}
    CNDA=${CONDA_PREFIX:+$(ansi ${MNML_VIRTUALENV_CONDA_COLOR} ${CONDA_PREFIX:t})}
    echo -n ${(pj.$MNML_VIRTUALENV_CONDA_SEPARATOR.)$(print "$VENV" "$CNDA")}
}
