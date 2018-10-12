# geometry changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2.0.0 - [Unreleased]

### Breaking
- Plugins are now just functions
- Builtin functions have been prefixed with `geometry_`
- Renamed a bunch of environment variables for functions to be
  - `GEOMETRY_<FUNCTION_NAME>_[COLOR|SYMBOL|WORD]`

### Added
- Background-jobs plugin as builtin function
- Support for left-prompt customization
- Path and hostname as left prompt
- Git stash indicator (thanks [ev-agelos](https://github.com/ev-agelos)!)

### Removed
- Root color for status symbol

### Changed
- Using `zsh-async` for right-prompt (git, hg, etc)
- Rebased on top of mnml - replacing plugins with simple functions

### Fixed
- Fix conflict count on non top-level directory

## 1.0.0 - 2017-04-05
### Added
- Change Log file
- Initial release features

[Unreleased]: https://github.com/geometry-zsh/geometry/compare/v1.0.0...HEAD
