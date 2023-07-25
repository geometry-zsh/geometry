Output functions.gif

Require echo

Set Shell "zsh"
Set FontSize 16
Set Width 1200
Set Height 600

Hide
Type ". $PWD/../geometry.zsh" Enter
Type "setopt interactivecomments" Enter
Type "GEOMETRY_PROMPT=(geometry_newline geometry_path geometry_newline geometry_status)" Enter
Type "clear" Enter
Show

Type '# lets define a new function' Sleep 200ms Alt+Enter
Type 'cool() { echo "(~~ cOOl ~~)" }' Sleep 300ms Enter
Type 'cool' Sleep 200ms Enter

Type '# whats in our current PROMPT?' Sleep 200ms Alt+Enter
Type 'echo $GEOMETRY_PROMPT' Sleep 300ms Enter

Type '# lets add our cool function to the left' Sleep 200ms Alt+Enter
Type 'GEOMETRY_PROMPT+=(cool)' Sleep 300ms Enter

Type '# <-- look! its now in our prompt!' Sleep 200ms Alt+Enter
Type '# but what if we have a slow function?' Sleep 200ms Alt+Enter

Type 'snail() { sleep 3; echo "@_. "}' Sleep 300ms Enter
Type 'snail' Enter Sleep 3s

Type '# the right prompt runs commands in the background' Sleep 200ms Alt+Enter 
Type '# so your shell always stays responsive' Sleep 200ms Alt+Enter
Type 'GEOMETRY_RPROMPT+=(snail)' Sleep 300ms Enter
Type 'ls' Sleep 300ms Enter

Type@333ms '1..2..3..'
Hide
Type '#  hello snail! ->' Alt+Enter
Show

Type "git clone https://github.com/geometry-zsh/geometry"

Sleep 5s
