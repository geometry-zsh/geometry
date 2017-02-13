# Rustup

Rustup plugin. Displays the currently selected rust toolchain when in a directory or git repository with Cargo.toml
It requires [rustup_prompt_helper][].

## Installation

    cargo install rustup_prompt_helper

## Configuration

```sh
GEOMETRY_PROMPT_PLUGINS+=(rustup)
```

### Colors

```sh
GEOMETRY_COLOR_RUSTUP_STABLE="green"
GEOMETRY_COLOR_RUSTUP_BETA="yellow"
GEOMETRY_COLOR_RUSTUP_NIGHTLY="red"
```

### Symbols

```sh
GEOMETRY_SYMBOL_RUSTUP="⚙"
```

[rustup_prompt_helper]: https://github.com/ijanos/rustup_prompt_helper
