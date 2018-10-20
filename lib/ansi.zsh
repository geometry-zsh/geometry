# ansi - ansi <color> <text> - wrap text in ansi color

(( $+commands[ansi] )) && { >&2 echo "lib/ansi.zsh: ansi function is already defined"; return }

function ansi { (($# - 2)) || echo "%F{$1}$2%f" }
