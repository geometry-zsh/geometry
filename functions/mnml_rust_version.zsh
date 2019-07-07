# mnml_rust_version - display the current version of rust (by @drager)

mnml_rust_version() {
    { test -f Cargo.toml || ls -1 '*rs' 2>/dev/null; } || return 1

  	local rust_version=$(rustc --version | \grep --color=never -oE '[0-9]+\.[0-9]+\.[0-9]')
  	
    ansi ${MNML_RUST_VERSION_COLOR:=red} v$rust_version
}
