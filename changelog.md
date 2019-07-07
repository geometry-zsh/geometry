# mnml changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2.0.0 - mnml

Renamed from mnml to mnml

### Added
- MNML_STATUS_SYMBOL_COLOR_HASH_COLORS for changing the has colors (thanks @MarioRicalde!)
- MNML_INFO array for running functions on enter
- `mnml_jobs`: function showing number of jobs
- `mnml_npm_package_version`: function showing npm/yarn package version (thanks @drager!)
- `mnml_rust_version`: function showing rustc version (thanks @drager!)
- MNML_DEBUG which helped hunt down lots of errors (thanks @MarioRicalde!)
- New logo and branding by @MarioRicalde!

### Changed
- Right prompt renders asynchronously via file descriptors
- Left prompt supports customization via `MNML_PROMPT`
- Functions read environment variables dynamically
- `mnml_git`: Git stash indicator (thanks @ev-agelos!)

### Deprecated
- Plugins are now simple `mnml_` prefixed functions (based on subnixr/minimal)
- MNML_PLUGINS{,SECONDARY} are now MNML_PROMPT and MNML_RPROMPT
- `MNML_[COLOR|SYMBOL]_PLUGIN_NAME` and most other environment variables
  - See the readme or `grep MNML_ functions/*`
- MNML_GIT_SHOW_{CONFLICTS/TIME/STASHES} no longer exist

### Removed
- Root color for status symbol
- 409 lines of code (60% smaller, from 676 to 267)

### Fixed
- Fix conflict count on non top-level directory

## 1.0.0 - 2017-04-05
### Added
- Change Log file
- Initial release features

[Unreleased]: https://github.com/mnml-zsh/mnml/compare/v1.0.0...HEAD
