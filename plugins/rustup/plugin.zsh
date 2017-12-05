# Color definitions
GEOMETRY_COLOR_RUSTUP_stable=${GEOMETRY_COLOR_RUSTUP_STABLE:-green}
GEOMETRY_COLOR_RUSTUP_beta=${GEOMETRY_COLOR_RUSTUP_BETA:-yellow}
GEOMETRY_COLOR_RUSTUP_nightly=${GEOMETRY_COLOR_RUSTUP_NIGHTLY:-red}

# Symbol definitions
GEOMETRY_SYMBOL_RUSTUP=${GEOMETRY_SYMBOL_RUSTUP:-"⚙"}

geometry_prompt_rustup_setup() {
  (( $+commands[rustup_prompt_helper] )) || return 1
}

geometry_prompt_rustup_check() {
    test -f Cargo.toml && return 0
     _git_dir=`git rev-parse --git-dir 2>/dev/null`
    test -f "${_git_dir/\.git/Cargo.toml}" && return 0
    return 1
}

geometry_prompt_rustup_render() {
    GEOMETRY_RUSTUP_TOOLCHAIN="$(rustup_prompt_helper 2> /dev/null)"
    GEOMETRY_COLOR_RUSTUP=${(e)GEOMETRY_RUSTUP_TOOLCHAIN:+\$GEOMETRY_COLOR_RUSTUP_${GEOMETRY_RUSTUP_TOOLCHAIN}}
    echo $(prompt_geometry_colorize $GEOMETRY_COLOR_RUSTUP $GEOMETRY_SYMBOL_RUSTUP)
}
