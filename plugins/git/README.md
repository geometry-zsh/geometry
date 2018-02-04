# Git

The git plugin is one of the most developed plugins in geometry.

## Features

### Elapsed time since last git commit

By default, geometry shows you the time since a commit has been made in the current repository. You can choose to disable this check by setting the
`PROMPT_GEOMETRY_GIT_TIME` variable to `false`.

We recommend doing this if the prompt is too slow on large repositories.

### Count git conflicts

You can have the prompt display both the number of files with
conflicts as well as the total number of conflicts by setting the
`PROMPT_GEOMETRY_GIT_CONFLICTS` environment variable to `true`.

This option chooses between `rg`, `ag` or `grep`, depending on which is available. `rg` has the highest priority, followed by `ag` and finally defaulting to `grep`.

**If you don't have `rg` or `ag` installed, this might slow down your prompt. Proceed with caution.**

![git_conflicts](/screenshots/git_conflicts.png)

### Use long or short time format

You can format the time since last commit. By default, it will only show either
seconds (`12s`), minutes (`2m`), hours (`5h`) or days (`30d`). However, by setting the `PROMPT_GEOMETRY_GIT_TIME_LONG_FORMAT` environment variable to `true` you can enhance its precision, displaying all of the previous settings, e.g: `12h 30m 53s`.

### 'No commits' message

When you create a new repo, geometry can display a "no commits" message, where
it would, usually, display the time since last commit. This behaviour can be
unchecked by setting the `PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY` variable to
`false`.

You can also customize the message by changing the
`GEOMETRY_GIT_NO_COMMITS_MESSAGE` to whatever you would like the message to be.

### Hide stash indicator

By default, we show an indicator if there are any git stashes `●`.
If you would like to hide this indicator, set `PROMPT_GEOMETRY_GIT_SHOW_STASHES=false`.

You can also change the symbol and color with `GEOMETRY_SYMBOL_GIT_STASHES`, and
`GEOMETRY_COLOR_GIT_STASHES`.

## Symbols

The following symbols can be overriden:

```sh
GEOMETRY_SYMBOL_GIT_DIRTY="⬡"                 # when repo has "dirty" state
GEOMETRY_SYMBOL_GIT_CLEAN="⬢"                 # when repo has "clean" state
GEOMETRY_SYMBOL_GIT_BARE="⬢"                  # when repo is bare (no working tree)
GEOMETRY_SYMBOL_GIT_REBASE="\uE0A0"           # when in middle of rebase
GEOMETRY_SYMBOL_GIT_UNPULLED="⇣"              # when there are unpulled changes
GEOMETRY_SYMBOL_GIT_UNPUSHED="⇡"              # when there are unpushed changes
GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED="◆"      # when all conflicts have been solved
GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED="◈"    # when there are still unsolved conflicts
```

## Colors

```sh
GEOMETRY_COLOR_GIT_DIRTY=red                # when repo has "dirty" state
GEOMETRY_COLOR_GIT_CLEAN=green              # when repo has "clean" state
GEOMETRY_COLOR_GIT_BARE=blue               # when repo is bare (no working tree)
GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED=red   # when there are unsolved conflicts
GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED=green   # when all conflicts have been solved
GEOMETRY_COLOR_GIT_BRANCH=242               # branch name color
```

## Flags

```sh
PROMPT_GEOMETRY_GIT_CONFLICTS=false         # show info if there is a merge conflict
PROMPT_GEOMETRY_GIT_TIME=true               # display time since last commit
PROMPT_GEOMETRY_GIT_TIME_LONG_FORMAT=false  # use long format for time since last commit
PROMPT_GEOMETRY_GIT_TIME_SHOW_EMPTY=true    # whether to show time if there is no commits
```

## Misc

```sh
GEOMETRY_GIT_NO_COMMITS_MESSAGE="no commits"# message where repository has no commits
GEOMETRY_GIT_SEPARATOR="::"                 # customize git character separator
```
