---
name: issue
about: report something surprising
title: ''
labels: ''
assignees: ''

---

<!-- This template helps us help you faster, please follow the checklist at the bottom <3 -->

Describe the bug here

<!-- share your system, shell, and terminal -->
* System: Ubuntu 18.04/macOS 10.13.1/WSL on Windows 10
* Terminal: st 0.8.2/alacritty 0.6.0/iTerm2 3.3.7
* Shell: zsh v5.4.1

<!-- starting with the following zshrc, can you reproduce the issue? -->
<!-- please share any modifications necessary -->

```zsh
# ~/.zshrc
test -d ~/.geometry || git clone https://github.com/geometry-zsh/geometry.git ~/.geometry
source ~/.geometry/geometry.zsh
```
