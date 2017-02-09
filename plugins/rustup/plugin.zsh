# Color definitions
GEOMETRY_COLOR_RUSTUP_stable=${GEOMETRY_COLOR_RUSTUP_STABLE:-green}
GEOMETRY_COLOR_RUSTUP_beta=${GEOMETRY_COLOR_RUSTUP_BETA:-yellow}
GEOMETRY_COLOR_RUSTUP_nightly=${GEOMETRY_COLOR_RUSTUP_NIGHTLY:-red}

# Symbol definitions
GEOMETRY_SYMBOL_RUSTUP=${GEOMETRY_SYMBOL_RUSTUP:-"⚙"}
GEOMETRY_SYMBOL_RUSTUP_SEPARATOR=${GEOMETRY_SYMBOL_RUSTUP_SEPARATOR:-"$GEOMETRY_GIT_SEPARATOR"}

geometry_prompt_rustup_setup() {}

geometry_prompt_rustup_render() {
    if (( $+commands[rustup_prompt_helper] )); then
        git rev-parse --git-dir > /dev/null 2>&1 || GEOMETRY_SYMBOL_RUSTUP_SEPARATOR=""
        GEOMETRY_RUSTUP_TOOLCHAIN="$(rustup_prompt_helper 2> /dev/null)"
        GEOMETRY_COLOR_RUSTUP=${(e)GEOMETRY_RUSTUP_TOOLCHAIN:+\$GEOMETRY_COLOR_RUSTUP_${GEOMETRY_RUSTUP_TOOLCHAIN}}
        GEOMETRY_RUSTUP=$(prompt_geometry_colorize $GEOMETRY_COLOR_RUSTUP $GEOMETRY_SYMBOL_RUSTUP)
        echo "$GEOMETRY_SYMBOL_RUSTUP_SEPARATOR $GEOMETRY_RUSTUP"
    fi
}

geometry_plugin_register rustup
