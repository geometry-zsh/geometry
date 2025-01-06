<!-- This template helps us help you faster, here are a few examples -->

Describe the bug here

<!-- share your system, shell, and terminal -->
* System: Ubuntu 20.04 / macOS 10.15.0 / WSL on Windows 10
* Terminal: st 0.8.2 / ghostty 1.0.1 / iTerm2 3.3.7
* Shell: zsh v5.9

<!-- starting with the following zshrc, can you reproduce the issue? -->

```zsh
# ~/.zshrc
test -d ~/.geometry || git clone https://github.com/geometry-zsh/geometry.git ~/.geometry
source ~/.geometry/geometry.zsh
```
<!-- please share whatever modifications are needed for us to reproduce the issue -->
