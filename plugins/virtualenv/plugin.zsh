# Color definitions
DEFAULT_COLOR=${GEOMETRY_COLOR_PROMPT:-green}
GEOMETRY_COLOR_VIRTUALENV=${GEOMETRY_COLOR_VIRTUALENV:-$DEFAULT_COLOR}
GEOMETRY_COLOR_CONDA=${GEOMETRY_COLOR_CONDA:-$DEFAULT_COLOR}
GEOMETRY_VIRTUALENV_CONDA_SEPARATOR=${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR:-:}


geometry_prompt_virtualenv_setup() {}

geometry_prompt_virtualenv_check() {
    [ -n "${VIRTUAL_ENV}" -o -n "${CONDA_PREFIX}" ]
}

geometry_prompt_virtualenv_render() {

    if [ -n "${VIRTUAL_ENV}" ]; then

        virtualenv_ref=$(basename $VIRTUAL_ENV)
        virtualenv_str="$(prompt_geometry_colorize $GEOMETRY_COLOR_VIRTUALENV ${virtualenv_ref})"

        if [ -n "${CONDA_PREFIX}" ]; then
            conda_ref="$(basename $CONDA_PREFIX)"
            virtualenv_str="${virtualenv_str}${GEOMETRY_VIRTUALENV_CONDA_SEPARATOR}$(prompt_geometry_colorize $GEOMETRY_COLOR_CONDA ${conda_ref})"
        fi

        echo "$virtualenv_str"

    elif [ -n "${CONDA_PREFIX}" ]; then
        conda_ref="$(basename $CONDA_PREFIX)"
        echo "$(prompt_geometry_colorize $GEOMETRY_COLOR_CONDA ${conda_ref})"
    fi
}

# Self-register plugin
geometry_plugin_register virtualenv
