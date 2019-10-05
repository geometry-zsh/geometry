# geometry_npm_package_version - display the current folder's npm package version from package.json (by @drager)

geometry_npm_package_version() {
    [[ -f package.json ]] || return 1

    : ${GEOMETRY_NPM_PACKAGE_VERSION_SYMBOL:="📦"}
    : ${GEOMETRY_NPM_PACKAGE_VERSION_SYMBOL_COLOR:=red}
    : ${GEOMETRY_NPM_PACKAGE_VERSION_COLOR:=red}

  	local npm_package_version="$(\grep version package.json | \grep --color=never -oE '[0-9]+\.[0-9]+\.[0-9]')"
  	
    local symbol="$(ansi $GEOMETRY_NPM_PACKAGE_VERSION_SYMBOL_COLOR $GEOMETRY_NPM_PACKAGE_SYMBOL)"
    local version="$(ansi $GEOMETRY_NPM_PACKAGE_VERSION_COLOR v$npm_package_version)"
    echo -n $symbol $version
}
