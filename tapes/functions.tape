Output functions.gif

Require echo

Set Shell "zsh"
Set FontSize 16
Set Width 1200
Set Height 600

Hide
Type ". $PWD/../geometry.zsh" Enter
Type "setopt interactivecomments" Enter
Type "setopt emacs" Enter
Type "GEOMETRY_PROMPT=(geometry_newline geometry_path geometry_newline geometry_status)" Enter
Type "clear" Enter
Show

Type '# lets define a new function' Sleep 300ms Alt+Enter
Type 'cool() { echo "⏀ " }' Sleep 450ms Enter
Type 'cool' Sleep 300ms Enter

Type '# whats in our current PROMPT?' Sleep 300ms Alt+Enter
Type 'echo $GEOMETRY_PROMPT' Sleep 450ms Enter

Sleep 1s

Type '# lets add our cool function to the left' Sleep 300ms Alt+Enter
Type 'GEOMETRY_PROMPT+=(cool)' Sleep 450ms Enter

Type '#  <- look! its now in our prompt!' Sleep 300ms Enter
Sleep 1s

Type '# but what if we have a slow function?' Sleep 300ms Alt+Enter

Type 'snail() { sleep 4; echo "@_. "}' Sleep 450ms Enter
Type 'snail' Enter
Sleep 4s

Type '# the right prompt runs commands in the background' Sleep 300ms Alt+Enter 
Type '# so your shell always stays responsive' Sleep 300ms Alt+Enter
Sleep 1s
Type 'GEOMETRY_RPROMPT+=(snail)' Enter

Type@300ms '# 1..2..3..'
Hide
Type@5ms '                       hello snail! ->'
Show

Sleep 4s Alt+Enter Alt+Enter

Type "git clone https://github.com/geometry-zsh/geometry"

Sleep 5s
