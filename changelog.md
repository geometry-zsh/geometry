# geometry changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2.0.1 - 2019-08-21

### Fixed
- zsh v5.0.0 support

## 2.0.0 - 2019-08-21

### Added
- New logo and branding by @MarioRicalde!
- `GEOMETRY_INFO` array for running functions on enter with an empty command
- `geometry_jobs` function showing number of jobs
- `geometry_npm_package_version` function showing npm/yarn package version (thanks @drager!)
- `geometry_rust_version` function showing rustc version (thanks @drager!)
- `GEOMETRY_STATUS_SYMBOL_COLOR_HASH_COLORS` for changing the hash colors (thanks @MarioRicalde!)

### Changed
- Left prompt supports customization via `GEOMETRY_PROMPT`
- Right prompt renders asynchronously via file descriptors
- Functions read environment variables dynamically
- `geometry_git` has a stash indicator (thanks @ev-agelos!)
- Plugins are now simple `geometry_` prefixed functions (based on subnixr/minimal)

### Deprecated
- `GEOMETRY_PLUGINS`, and `GEOMETRY_PLUGINS_SECONDARY` are now `GEOMETRY_PROMPT`, and `GEOMETRY_RPROMPT`
- `GEOMETRY_[COLOR|SYMBOL]_PLUGIN_NAME` and most other environment variables are deprecated (see options.md for new variables)
- `GEOMETRY_GIT_SHOW_{CONFLICTS,TIME,STASHES}` no longer exist

### Removed
- Root color for status symbol
- 409 lines of code (60% smaller, from 676 to 267)

### Fixed
- Fix conflict count on non top-level directory
- Dozens of other small fixes

## 1.0.0 - 2017-04-05
### Added
- Change Log file
- Initial release features

[Unreleased]: https://github.com/geometry-zsh/geometry/compare/v1.0.0...HEAD
