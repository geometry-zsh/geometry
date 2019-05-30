GEOMETRY_COLOR_EXIT_CODE=${GEOMETRY_COLOR_EXIT_CODE:-magenta}
GEOMETRY_EXIT_CODE_SEPARATOR=${GEOMETRY_EXIT_CODE_SEPARATOR:-":( "}

local RETCODE=0

get_exit_code() {
    RETCODE=$?
}

geometry_prompt_exit_code_setup() {
    add-zsh-hook precmd get_exit_code
}

geometry_prompt_exit_code_check() {
    [[ $RETCODE != 0 ]]
}

geometry_prompt_exit_code_render() {
    echo $(prompt_geometry_colorize $GEOMETRY_COLOR_EXIT_CODE "$GEOMETRY_EXIT_CODE_SEPARATOR$RETCODE")
}
