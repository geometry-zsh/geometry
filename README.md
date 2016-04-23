# geometry

geometry is a minimal zsh prompt theme.

![geometry](screenshots/geometry.png)

I started chopping away at [Avit](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/avit.zsh-theme) until I ended up with something minimal and inspired on [Pure](https://github.com/sindresorhus/pure).

What it does:

- display current git branch
- display colored time since last commit
- display state (clean/dirty) of the repo
- display arrows indicating if you need to pull, push or if you are mid-rebase
- set the terminal title to current command and directory
- makes you the coolest hacker in the whole Starbucks

Much like [Pure](https://github.com/sindresorhus/pure), geometry adds a different marker
if the last command result is different from `0`. It also sets the title to
`[command @] directory`. Check the title and marker here:

![title_marker](screenshots/title_marker.png)

## Installing

### antigen

Just add `antigen bundle frmendes/geometry` to your `.zshrc`.

### oh-my-zsh

Move `geometry.zsh` to `$HOME/.oh-my-zsh/custom/themes/geometry.zsh-theme` and
set `ZSH_THEME="geometry"` in your `.zshrc`.

