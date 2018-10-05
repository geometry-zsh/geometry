#!zsh

(( $+commands[color] )) && {
  >&2 echo "lib/colo.zsh: color is already defined"
  return
}

function color {
  echo "%F{$1}$2%f"
}