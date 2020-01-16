# geometry changelog

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 2.2.0 - 2020-01-13

### Fixed
- Prepended space for left prompt (thanks @Konsonanz!)
- Hide extra spaces due to functions that have nothing to show (thanks @Konsonanz!)

### Removed
- Set default GEOMETRY_INFO to blank

## 2.1.0 - 2019-12-27

### Improved
- lazy load functions with autoload instead of sourcing (thanks @alxbl!)

### Added
- geometry_newline for two-line prompts (thanks @ducklin5)
- geometry::hostcolor to allow host-based colorization for all (thanks @crasx!)

### Fixed
- geometry_git complaining when not in a work-tree
- geometry_git works in submodules now, (thanks @JokeNeverSoke!)

### Removed
- GEOMETRY_GIT_SEPARATOR hidden feature, was the only function that didnt work like the others.
Now uses GEOMETRY_SEPARATOR like everything else.
- GEOMETRY_STATUS_SYMBOL_COLOR_HASH is deprecated, now just use GEOMETRY_STATUS_COLOR=$(geometry::hostcolor) (thanks @crasx!)

## 2.0.5 - 2019-10-14

### Fixed
- Problem sourcing functions

## 2.0.4 - 2019-10-14

### Fixed
- Breaking GEOMETRY_SEPARATOR, especially on left prompt (thanks @diogoazevedos!)

### Improved
- Respond to changes in GEOMETRY_SEPARATOR dynamically
- Reduced core to 62 lines

## 2.0.3 - 2019-10-11

### Added
- geometry_exitcode - from @alxbl, a way to see the exact exit code in the prompt

### Fixed
- Accidental export of local `fun` variable
- extra "'" in separator for geometry_hg
- Quoting for zsh 5.0.0 - thanks @psprint
- Hid GEOMETRY_TIME_COLOR_SHORT, NEUTRAL, LONG, ROOT, EXEC_TIME_FILE, and LAST_STATUS under GEOMETRY array
- Renamed PCFD to GEOMETRY_ASYNC_FD

## 2.0.2 - 2019-09-04

### Fixed
- Use default terminal color instead of white
- Improve geometry_kube logic (thanks @olegTarassov!)
- Showing git checkout when HEAD is not a symbolic ref

### Added
- GEOMETRY_KUBE_SEPARATOR (thanks @olegTarassov!)

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
