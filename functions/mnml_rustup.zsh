# mnml_rustup - display a symbol colored with the currently selected rustup toolchain

(( $+commands[rustup] )) || return

mnml_rustup() {
    ( ${MNML_RUSTUP_PIN:=false} ) || { cargo locate-project 2>/dev/null || { echo -n '' && return; } }

    : ${MNML_RUSTUP_STABLE_COLOR:=green}
    : ${MNML_RUSTUP_BETA_COLOR:=yellow}
    : ${MNML_RUSTUP_NIGHTLY_COLOR:=red}

    local toolchain="$(rustup show | grep 'stable|beta|nightly' | head -n 1 |  cut -d '-' -f 1 | tr -d '\n' 2> /dev/null)"
    local rustup_color=${(e)toolchain:+\$MNML_RUSTUP_${toolchain:u}_COLOR}

    ansi $rustup_color ${MNML_RUSTUP_SYMBOL:=⚙}
}
