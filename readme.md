# geometry

**warning**: this is an experimental rewrite based on the ergonomics and code of mnml. lots of features are missing.

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/geometry-zsh/Lobby)
[![Trello](https://img.shields.io/badge/trello-board-blue.svg)](https://trello.com/b/GfM4e6Ro/geometry)
[![GitHub release](https://img.shields.io/github/release/geometry-zsh/geometry.svg)](https://github.com/geometry-zsh/geometry/releases/latest)

geometry is a minimalistic, fully customizable zsh prompt theme.

![geometry](screenshots/screencast.gif)

geometry starts small, with good defaults, and allows you to customize it at your own will. It can be as simple or complex as you like.

* [Installing](#installing)
* [Dependencies](#dependencies)
* [What it Does](#what-it-does)
* [Plugins](#plugins)
* [Configuration](#configuration)
* [FAQs](#faqs)
* [Maintainers](#maintainers)

## Installing

*K, I'm sold. Beam me up, Scotty.*


### Install using antigen

Just add `antigen theme geometry-zsh/geometry` to your `.zshrc`.


### Install using oh-my-zsh

Move the entire `geometry` folder to `$HOME/.oh-my-zsh/custom/themes`, and set `ZSH_THEME="geometry/geometry"` in your `.zshrc`.


### Install using zplug

Add `zplug "geometry-zsh/geometry"` to your `.zshrc`.

### Install using zr

Add `geometry-zsh/geometry` to your `zr load` command.

### Manual install

Clone this repository as follows:

    git clone https://github.com/geometry-zsh/geometry
    cd geometry
    git submodule update --init --recursive

Then add it to your `.zshrc` configuration:

    source /path/to/geometry/geometry.zsh

## Dependencies

The symbol for rebasing comes from a [Powerline patched font](https://github.com/powerline/fonts). If you want to use it, you're going to need to install one from the font repo. The font used in the screenshots is [Roboto Mono](https://github.com/powerline/fonts/tree/master/RobotoMono). You can also try to [patch it yourself](https://github.com/powerline/fontpatcher).

You can also change the rebase symbol by setting the `GEOMETRY_SYMBOL_GIT_REBASE` variable.

## What it does

All geometry does is run simple functions to customize the left and write prompts.

We bundle a few useful functions to start out with, that can:

- give you a custom, colorizable prompt symbol
- change the prompt symbol color according to the last command exit status
- make the prompt symbol color change with your hostname
- make you the coolest hacker in the whole Starbucks

~~The right side prompt is printed asynchronously, so you know it's going to be fast™.~~ UNDER CONSTRUCTION

## Commands

geometry has very little architecture. By default, we display a status symbol on the left, hostname and directory on the right.

These come from the `commands/` folder and are defined as `geometry_status`, `geometry_hostname`, and `geometry_path`.

To add more commands, just source the function you want, and add it to the `GEOMETRY_PROMPT` environment variable

```sh
GEOMETRY_PROMPT=(geometry_status geometry_path)
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*.

Its worth looking into the `commands` directory to see if there are environment variables to make common customizations.

Please check out and share third-party commands on our [Commands wiki page](https://github.com/geometry-zsh/geometry/wiki/Commands).

## Configuration

Pretty much everything in geometry can be changed by setting a variable **before you load the theme**.

The default options try to balance the theme in order to be both lightweight and contain useful features.

### Symbols

There are a set of symbols available which you can override with environment variables.

```shell
GEOMETRY_SYMBOL_OK="▲"                 # default prompt symbol
GEOMETRY_SYMBOL_ERROR="△"              # displayed when exit value is != 0
```

You can find configuration for specific functions under the [functions](/functions) directory.

### Colors

The following color definitions are available for configuration:

```shell
GEOMETRY_COLOR_EXIT_VALUE="magenta"         # prompt symbol color when exit value is != 0
GEOMETRY_COLOR_PROMPT="white"               # prompt symbol color
GEOMETRY_COLOR_ROOT="red"                   # root prompt symbol color
GEOMETRY_COLOR_DIR="blue"                   # current directory color
```

You can find color configuration for specific plugins under the
[plugins](/plugins) directory.


### Misc

```shell
GEOMETRY_PROMPT_PREFIX="$'\n'"              # prefix prompt with a new line
GEOMETRY_PROMPT_SUFFIX=""                   # suffix prompt
GEOMETRY_PROMPT_PREFIX_SPACER=" "           # string to place between prefix and symbol
GEOMETRY_SYMBOL_SPACER=" "                  # string to place between symbol and directory
GEOMETRY_DIR_SPACER=" "                     # string to place between directory and suffix
GEOMETRY_PLUGIN_SEPARATOR=" "               # use ' ' to separate right prompt parts
GEOMETRY_GREP=""                            # define which grep-like tool to use (By default it looks for rg, ag and finally grep)
```

### Features

#### ~~Async `RPROMPT`~~

geometry runs `RPROMPT` asynchronously to avoid blocking on costly operations. This is enabled by default but you can disable it by setting `PROMPT_GEOMETRY_RPROMPT_ASYNC` to `false`.

#### Randomly colorize prompt symbol

Your prompt symbol can change colors based on a simple hash of your hostname. To enable this, set `PROMPT_GEOMETRY_COLORIZE_SYMBOL` to `true`.

![colorize](screenshots/colorize.png)

#### Colorize prompt symbol when root

You can have your prompt symbol change color when running under the `root` user.

To activate this option, just set `PROMPT_GEOMETRY_COLORIZE_ROOT` to `true`. Both symbol and color can be customized by overriding the `GEOMETRY_SYMBOL_ROOT` and `GEOMETRY_COLOR_ROOT` variables.

Note that this option overrides the color hashing of your prompt symbol.

## FAQs

**I found a bug. What do I do?**

Open an issue. There are probably more people with that very same problem so we like to keep everything documented in case someone else comes looking for a solution.

If you can provide info about your terminal, OS and zsh version it would be a great starting point. It would also be of great assistance if you are able to write steps to reproduce the issue.

**I have an idea for a feature, can I submit a PR?**

Please do. geometry is a work in progress, so if you want to help improve it, your
idea is welcome. We're not looking to add a lot of default features to not
overload the theme. However, plugins are a great way of extending geometry
without overloading it. If you have an idea for a plugin, feel free to
submit it and we'll always give our best to provide constructive feedback and
help you improve.

**Is there anything specific I can do to help?**

There are always things we would like to improve. Feel free to jump in on any issue to tackle it or just to provide your feedback.

As for PRs, we are currently looking to improve performance.

**Why doesn't my prompt look like the screenshots?**

Well, I use [`z`](https://github.com/rupa/z) for jumping around and
[`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting/)
for those pretty command colors. You might also want to look into [base16](https://github.com/chriskempson/base16) to get similar colors.

**Where do I put my geometry configuration files?**

Well, anywhere in your `.zshrc` file should be fine, **as long as you define variables before geometry is loaded**.

**That's a neat font you have there. Can I have it?**

Sure. It's [Roboto Mono](https://fonts.google.com/specimen/Roboto+Mono). Don't forget to use the [powerline patched version](https://github.com/powerline/fonts/tree/master/RobotoMono) if you want to use the default rebase symbol.

## Maintainers

geometry is currently maintained by [fribmendes](https://github.com/fribmendes), [desyncr](https://github.com/desyncr) and [jedahan](https://github.com/jedahan).

A big thank you to those who have previously [contributed](https://github.com/geometry-zsh/geometry/graphs/contributors).
