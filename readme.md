# geometry

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/geometry-zsh/Lobby)
[![Trello](https://img.shields.io/badge/trello-board-blue.svg)](https://trello.com/b/GfM4e6Ro/geometry)
[![GitHub release](https://img.shields.io/github/release/geometry-zsh/geometry.svg)](https://github.com/geometry-zsh/geometry/releases/latest)

geometry is a minimalistic, fully customizable zsh prompt theme.

![geometry](screenshots/screencast.gif)

geometry starts small, with good defaults, and allows you to customize it at your own will. It can be as simple or complex as you like.

* [Installing](#installing)
* [Dependencies](#dependencies)
* [What it Does](#what-it-does)
* [Functions](#functions)
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
- display current git branch, state and time since last commit
- tell you whether you need to pull, push or if you're mid-rebase
- display the number of conflicting files and total number of conflicts
- display if there is a stash
- display the running time of long running commands
- set the terminal title to current command and directory
- make you the coolest hacker in the whole Starbucks

The right side prompt is printed asynchronously, so you know it's going to be fast™.

## Functions

geometry has very little architecture. By default, we display a status symbol and path on the left, git/hg status and hostname on the right.

These come from the `functions/` folder and are defined as `geometry_status`, `geometry_path`, `geometry_hostname`, `geometry_git`, and `geometry_hg`.

Most of these functions only render if it makes sense to (for example, if ssh'd to another computer or in a git directory).

To add more functions, just source or define them, and add it to the `GEOMETRY_PROMPT` or `GEOMETRY_RPROMPT` environment variable

```sh
GEOMETRY_PROMPT=(geometry_status geometry_path) # redefine left prompt
GEOMETRY_RPROMPT+=(geometry_exec_time) # append exec_time to defaults
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*.

Its worth looking into the [functions directory](/functions) to see if there are environment variables to make common customizations.

Please check out and share third-party functions on our [Functions wiki page](https://github.com/geometry-zsh/geometry/wiki/Functions).

## Configuration

Pretty much everything in geometry can be changed by setting a variable **before you load the theme**.

The default options try to balance the theme in order to be both lightweight and contain useful features.

Here we highlight some of the more commonly customized variables, but to see all of them, look at the header of each file in the [functions directory](/function).

### Symbols

There are a set of symbols available which you can override with environment variables.

```shell
GEOMETRY_STATUS_SYMBOL="▲"        # default prompt symbol
GEOMETRY_STATUS_SYMBOL_ERROR="△"  # displayed when exit value is != 0
```

### Colors

The following color definitions are available for configuration:

```shell
GEOMETRY_STATUS_COLOR_ERROR="magenta"  # prompt symbol color when exit value is != 0
GEOMETRY_STATUS_COLOR="white"          # prompt symbol color
GEOMETRY_STATUS_COLOR_ROOT="red"       # root prompt symbol color
GEOMETRY_PATH_COLOR="blue"             # current directory color
```

### Misc

```shell
GEOMETRY_SEPARATOR=" "    # use ' ' to separate function output
GEOMETRY_GIT_GREP=""      # define which grep-like tool to use (By default it looks for rg, ag and finally grep)
```

### Features

#### Async `RPROMPT`

geometry runs `RPROMPT` asynchronously to avoid blocking on costly operations.

#### Randomly colorize prompt symbol

Your prompt symbol can change colors based on a simple hash of your hostname. To enable this, set `GEOMETRY_STATUS_COLOR_HASH` to `true`.

![colorize](screenshots/colorize.png)

### Git

The git function is one of the most developed plugins in geometry, which is why we document it here.

#### Elapsed time since last git commit

By default, geometry shows you the time since a commit has been made in the current repository.
This can be disabled by setting `PROMPT_GEOMETRY_GIT_TIME` to `false`.

We recommend doing this if the prompt is too slow on large repositories.

#### Count git conflicts

You can have the prompt display both the number of files with conflicts as well as the total number of conflicts by setting `PROMPT_GEOMETRY_GIT_CONFLICTS` to `true`.

This option chooses between `rg`, `ag` or `grep`, depending on which is available. `rg` has the highest priority, followed by `ag` and finally defaulting to `grep`.

**If you don't have `rg` or `ag` installed, this might slow down your prompt. Proceed with caution.**

![git_conflicts](/screenshots/git_conflicts.png)

#### Use long or short time format

You can format the time since last commit. By default, it will only show either
seconds (`12s`), minutes (`2m`), hours (`5h`) or days (`30d`).

By setting `GEOMETRY_GIT_TIME_LONG_FORMAT` to `true` you can enhance its precision, displaying all of the previous settings, e.g: `12h 30m 53s`.

#### 'No commits' message

When you create a new repo, geometry can display a "no commits" message, where
it would, usually, display the time since last commit. This behaviour can be
unchecked by setting the `GEOMETRY_GIT_TIME_SHOW_EMPTY` to
`false`.

You can also customize the message by changing the
`GIT_NO_COMMITS_MESSAGE` to whatever you would like the message to be.

#### Hide stash indicator

By default, we show an indicator if there are any git stashes `●`.

If you would like to hide this indicator, set `GEOMETRY_GIT_SHOW_STASHES` to `false`.

You can also change the symbol and color with `GEOMETRY_GIT_SYMBOL_STASHES`, and `GEOMETRY_GIT_COLOR_STASHES`.

#### Full list of git features

Check out the environment variables in [functions/geometry_git](functions/geometry_git) for the full list of options

## FAQs

**I found a bug. What do I do?**

[Open an issue][]. There are probably more people with that very same problem so we like to keep everything documented in case someone else comes looking for a solution.

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

geometry is maintained by [fribmendes](https://github.com/fribmendes), [desyncr](https://github.com/desyncr) and [jedahan](https://github.com/jedahan).

A big thank you to those who have [contributed](https://github.com/geometry-zsh/geometry/graphs/contributors).

[Open an issue]: https://github.com/geometry-zsh/geometry/issues/new
