#!zsh

(( $+commands[color] )) && {
  >&2 echo "lib/color.zsh: color is already defined"
  return
}

function color {
  echo "%F{$1}$2%f"
}
