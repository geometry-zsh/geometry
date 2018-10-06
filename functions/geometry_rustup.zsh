# Rustup
#
# Display a symbol with the currently selected rustup toolchain

: ${GEOMETRY_RUSTUP_STABLE_COLOR:=green} #
: ${GEOMETRY_RUSTUP_BETA_COLOR:=yellow}  #
: ${GEOMETRY_RUSTUP_NIGHTLY_COLOR:=red}  #
: ${GEOMETRY_RUSTUP_SYMBOL:="⚙"}         # Symbol
: ${GEOMETRY_RUSTUP_PIN:=false}          # Always display

(( $+commands[rustup] )) || return

_geometry_rustup_check() {
    test $GEOMETRY_RUSTUP_PIN && return
    test -f Cargo.toml && return
    _git_dir=`git rev-parse --git-dir 2>/dev/null`
    test -f "${_git_dir/\.git/Cargo.toml}" && return
    return 1
}

function geometry_rustup {
    _geometry_rustup_check || return
    local toolchain="$(rustup show | tail -n 3 | head -n 1 |  cut -d '-' -f 1 2> /dev/null)"
    local rustup_color=${(e)toolchain:+\$GEOMETRY_RUSTUP_${toolchain:u}_COLOR}
    echo -n $(color $rustup_color $GEOMETRY_RUSTUP_SYMBOL)
}
