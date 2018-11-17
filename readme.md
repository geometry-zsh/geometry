# geometry

geometry is a minimalistic, fully customizable zsh prompt theme.

![geometry](screenshots/screencast.gif)

geometry starts small, with good defaults, and allows you to customize it at your own will.
It can be as simple or complex as you like.

* [Installing](#installing)
* [What it Does](#what-it-does)
* [Functions](#functions)
* [Configuration](#configuration)
* [FAQs](#faqs)
* [Maintainers](#maintainers)

## Installing

*K, I'm sold. Beam me up, Scotty.*

Any commands should be added to your `.zshrc`

plugin manager| `.zshrc` | one-time command [optional]
--------------|----------|----------------------------
[zr][]        | `zr load geometry-zsh/geometry`
[zplug][]     | `zplug "geometry-zsh/geometry"`
[antigen][]   | `antigen theme geometry-zsh/geometry`
**manually**  | `source geometry/geometry.zsh`  | `git clone https://github.com/geometry-zsh/geometry`
[oh-my-zsh][] | `ZSH_THEME="geometry/geometry"` | `git clone https://github.com/geometry-zsh/geometry $ZSH_CUSTOM/themes`

## What it does

All geometry does is run simple functions to customize the left and right prompts.

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

Geometry also has a secondary prompt that shows up when pressing enter with an empty command, which can be customized with `GEOMETRY_INFO`.

## Functions

geometry has very little architecture. By default, we display a status symbol and path on the left, command execution time, git/hg status, and hostname on the right.

These come from the `functions/` folder and are defined as `geometry_status`, `geometry_path`, `geometry_exec_time`, `geometry_git`, `geometry_hg`, and `geometry_hostname`.

Most of these functions only render if it makes sense to (for example, if ssh'd to another computer or in a git directory).

To add more functions, just source or define them, and add it to the `GEOMETRY_PROMPT` or `GEOMETRY_RPROMPT` environment variable

```sh
GEOMETRY_PROMPT=(geometry_status geometry_path) # redefine left prompt
GEOMETRY_RPROMPT+=(geometry_exec_time) # append exec_time to defaults
```

Its worth looking into the [functions directory](/functions) to see if there are environment variables to make common customizations.

Please check out and share third-party functions on our [Functions wiki page](https://github.com/geometry-zsh/geometry/wiki/Functions).

## Configuration

Pretty much everything in geometry can be changed by setting a variable.

The default options try to balance the theme in order to be both lightweight and contain useful features.

Here we highlight some of the more commonly customized variables, but to see all of them, look at the header of each file in the [functions directory](/function).

### general
```shell
GEOMETRY_SEPARATOR=" "    # use ' ' to separate function output
```

### geometry_status

There are a set of symbols available which you can override with environment variables.

```shell
GEOMETRY_STATUS_SYMBOL="▲"             # default prompt symbol
GEOMETRY_STATUS_SYMBOL_ERROR="△"       # displayed when exit value is != 0
GEOMETRY_STATUS_COLOR_ERROR="magenta"  # prompt symbol color when exit value is != 0
GEOMETRY_STATUS_COLOR="white"          # prompt symbol color
GEOMETRY_STATUS_COLOR_ROOT="red"       # root prompt symbol color
GEOMETRY_STATUS_COLOR_HASH=true        # color status symbol based on hostname
```

![colorize](screenshots/colorize.png)

### geometry_git

The git function is one of the most developed plugins in geometry. Here we show overrides and what they do.
**We recommend installing `rg` or `ag` for the best performance with `geometry_git`**

```shell
GEOMETRY_GIT_SYMBOL_REBASE="\uE0A0" # set the default rebase symbol to the powerline symbol 
GEOMETRY_GIT_GREP=ack               # define which grep-like tool to use (By default it looks for rg, ag and finally grep)
GEOMETRY_GIT_SHOW_TIME=false        # disable showing the time since a commit has been made in the current repository (can be slow on large repos)
GEOMETRY_GIT_CONFLICTS=true         # display both the number of files with conflicts as well as the total number of conflicts
GEOMETRY_GIT_TIME_DETAILED=true     # show full time (e.g. `12h 30m 53s`) instead of the coarsest interval (e.g. `12h`)
GEOMETRY_GIT_NO_COMMITS_MESSAGE=""  # hide the 'no commits' message in new repositories
GEOMETRY_GIT_SHOW_STASHES=false     # hide the `●` git stash indicator
GEOMETRY_GIT_SYMBOL_STASHES=x       # change the git stash indicator to `x`
GEOMETRY_GIT_COLOR_STASHES=blue     # change the git stash color to blue
```

![git_conflicts](/screenshots/git_conflicts.png)

## FAQs

**I found a bug. What do I do?**

[Open an issue][]. There are probably more people with that very same problem so we like to keep everything documented in case someone else comes looking for a solution.

If you can provide info about your terminal, OS and zsh version it would be a great starting point. It would also be of great assistance if you are able to write steps to reproduce the issue.

**I have an idea for a feature, can I submit a PR?**

Please do! geometry is a work in progress, so if you want to help improve it, your idea is welcome.
We want to keep the theme clean, so default features/functions should be minimal and context-aware.
If you have an idea for a function, feel free to submit it and we'll always give our best to provide constructive feedback and help you improve.

**Is there anything specific I can do to help?**

There are always things we would like to improve. Feel free to jump in on any issue to tackle it or just to provide your feedback.

**Why doesn't my prompt look like the screenshots?**

Well, I use [`z`](https://github.com/rupa/z) for jumping around and
[`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting/)
for those pretty command colors. You might also want to look into [base16](https://github.com/chriskempson/base16) to get similar colors.

**That's a neat font you have there. Can I have it?**

Sure. It's [Roboto Mono](https://fonts.google.com/specimen/Roboto+Mono). Don't forget to use the [powerline patched version](https://github.com/powerline/fonts/tree/master/RobotoMono) if you want to use the default rebase symbol.

## Maintainers

geometry is maintained by [fribmendes](https://github.com/fribmendes), [desyncr](https://github.com/desyncr) and [jedahan](https://github.com/jedahan).

A big thank you to those who have [contributed](https://github.com/geometry-zsh/geometry/graphs/contributors).

[Open an issue]: https://github.com/geometry-zsh/geometry/issues/new
[antigen]: https://github.com/zsh-users/antigen
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[zplug]: https://github.com/zplug/zplug
[zr]: https://github.com/jedahan/zr
