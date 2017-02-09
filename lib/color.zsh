# Define how to colorize before the variables
prompt_geometry_colorize() {
  echo "%F{$1}$2%f"
}

prompt_geometry_hash_color() {
  colors=(`seq 1 9`)

  if (($(echotc Co) == 256)); then
    colors+=(`seq 17 230`)
  fi

  local sum=0
  for i in {0..${#1}}; do
    ord=$(printf '%d' "'${1[$i]}")
    sum=$(($sum + $ord))
  done

  echo ${colors[$(($sum % ${#colors}))]}
}

# alias prompt_geometry_colorize as -g-color
-g-color() {
  prompt_geometry_colorize "$@"
}
