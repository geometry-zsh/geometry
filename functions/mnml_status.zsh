# mnml_status - show a symbol with error/success and root/non-root information

mnml_status() {
  : ${MNML_STATUS_COLOR:=white}
  : ${MNML_STATUS_COLOR_ERROR:=red}
  : ${MNML_STATUS_SYMBOL:=▲}
  : ${MNML_STATUS_SYMBOL_ERROR:=△}
  : ${MNML_STATUS_SYMBOL_ROOT:=▼}
  : ${MNML_STATUS_SYMBOL_ROOT_ERROR:=▽}

  ( ${MNML_STATUS_SYMBOL_COLOR_HASH:=false} ) && {
    local colors=({1..9})

    (($(echotc Co) == 256)) && colors+=({17..230})

    local sum=0; for c in ${(s::)^HOST}; do ((sum += $(print -f '%d' "'$c"))); done

    MNML_STATUS_COLOR=${colors[$(($sum % ${#colors}))]}
  }

  local color=MNML_STATUS_COLOR symbol=MNML_STATUS_SYMBOL
  [[ $UID = 0 || $EUID = 0 ]] && symbol+=_ROOT
  (( $MNML_LAST_STATUS )) && symbol+=_ERROR && color+=_ERROR

  ansi ${(P)color} ${(P)symbol}
}
