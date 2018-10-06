# geometry Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Changed
- Rebased on top of mnml
- Simplified architecture to work on functions instead of plugins
- Renamed a bunch of environment variables for functions to be
  - `GEOMETRY_FUNCTION_NAME_COLOR/SYMBOL/ETC`

### Removed
- Root color for status symbol

### Broke
- Weird tab complete bug I think

## [Unreleased]

### Added
- Background-jobs plugin as builtin plugin
- Support for left-prompt customization (contexts)
- Path and hostname as primary context plugins
- Git stash indicator (thanks [ev-agelos](https://github.com/ev-agelos)!)

### Changed
- Using `zsh-async` for right-prompt (git, hg, etc)

### Fixed
- Fix conflict count on non top-level directory

## 1.0.0 - 2017-04-05
### Added
- Change Log file
- Initial release features

[Unreleased]: https://github.com/geometry-zsh/geometry/compare/v1.0.0...HEAD
