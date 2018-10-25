# geometry_status - show a symbol with error/success and root/non-root information

geometry_status() {
  : ${GEOMETRY_STATUS_COLOR:=white}         # Color when everything is ok
  : ${GEOMETRY_STATUS_COLOR_ERROR:=magenta} # Color if there was an error
  : ${GEOMETRY_STATUS_COLOR_HASH:=false}    # Color indicates hostname

  : ${GEOMETRY_STATUS_SYMBOL:=▲}            # Default symbol
  : ${GEOMETRY_STATUS_SYMBOL_ERROR:=△}      # Error symbol
  : ${GEOMETRY_SYMBOL_STATUS_ROOT:=▲}       # Root symbol
  : ${GEOMETRY_SYMBOL_STATUS_ROOT_ERROR:=△} # Root error symbol

  (( $GEOMETRY_STATUS_SYMBOL_COLOR_HASH )) && {
    local colors=({1..9})

    (($(echotc Co) == 256)) && colors+=({17..230})

    local sum=0; for c (${(s::)^HOST}) ((sum += $(print -f '%d' "'$c")))

    GEOMETRY_STATUS_COLOR=${colors[$(($sum % ${#colors}))]}
  }

  GEOMETRY_STATUS_OKAY=$(ansi $GEOMETRY_STATUS_COLOR $GEOMETRY_STATUS_SYMBOL)
  GEOMETRY_STATUS_ERROR=$(ansi $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ERROR)
  GEOMETRY_STATUS_ROOT_OKAY=$(ansi  $GEOMETRY_STATUS_COLOR $GEOMETRY_STATUS_SYMBOL_ROOT)
  GEOMETRY_STATUS_ROOT_ERROR=$(ansi $GEOMETRY_STATUS_COLOR_ERROR $GEOMETRY_STATUS_SYMBOL_ROOT_ERROR)

  if (( $GEOMETRY_LAST_STATUS )); then
    [[ $UID = 0 || $EUID = 0 ]] && echo $GEOMETRY_STATUS_ROOT_ERROR || echo $GEOMETRY_STATUS_ERROR
  else
    [[ $UID = 0 || $EUID = 0 ]] && echo $GEOMETRY_STATUS_ROOT_OKAY || echo $GEOMETRY_STATUS_OKAY
  fi
}
