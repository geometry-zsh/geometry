# ansi - ansi <color> <text> - wrap text in ansi color

(( $+functions[ansi] )) || function ansi { (($# - 2)) || echo "%F{$1}$2%f" }
