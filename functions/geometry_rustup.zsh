# geometry_rustup - display a symbol colored with the currently selected rustup toolchain

geometry_rustup() {
    (( $+commands[rustup] )) || return

    ( ${GEOMETRY_RUSTUP_PIN:=false} ) || { cargo locate-project 2>/dev/null || { echo -n '' && return; } }

    : ${GEOMETRY_RUSTUP_STABLE_COLOR:=green}
    : ${GEOMETRY_RUSTUP_BETA_COLOR:=yellow}
    : ${GEOMETRY_RUSTUP_NIGHTLY_COLOR:=red}

    local toolchain="$(rustup show | grep 'stable|beta|nightly' | head -n 1 |  cut -d '-' -f 1 | tr -d '\n' 2> /dev/null)"
    local rustup_color=${(e)toolchain:+\$GEOMETRY_RUSTUP_${toolchain:u}_COLOR}

    ansi $rustup_color ${GEOMETRY_RUSTUP_SYMBOL:=⚙}
}
