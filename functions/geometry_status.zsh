# geometry_status - show a symbol with error/success and root/non-root information

geometry_status() {
  : ${GEOMETRY_STATUS_COLOR:=white}
  : ${GEOMETRY_STATUS_COLOR_ERROR:=red}
  : ${GEOMETRY_STATUS_SYMBOL:=▲}
  : ${GEOMETRY_STATUS_SYMBOL_ERROR:=△}
  : ${GEOMETRY_STATUS_SYMBOL_ROOT:=▼}
  : ${GEOMETRY_STATUS_SYMBOL_ROOT_ERROR:=▽}
  : ${GEOMETRY_STATUS_SHOW_CODE:=false}
  : ${GEOMETRY_STATUS_CODE_PREFIX:=' '}
  : ${GEOMETRY_STATUS_CODE_SUFFIX:=' '}

  ( ${GEOMETRY_STATUS_SYMBOL_COLOR_HASH:=false} ) && {
    local colors=({1..9})

    (($(echotc Co) == 256)) && colors+=({17..230})

    if (( ${+GEOMETRY_STATUS_SYMBOL_COLOR_HASH_COLORS} )); then
      colors=(${GEOMETRY_STATUS_SYMBOL_COLOR_HASH_COLORS})
    fi

    local sum=0; for c in ${(s::)^HOST}; do ((sum += $(print -f '%d' "'$c"))); done

    local index=$(($sum % ${#colors}))

    [[ "$index" -eq 0 ]] && index=1

    GEOMETRY_STATUS_COLOR=${colors[${index}]}
  }

  local color=GEOMETRY_STATUS_COLOR symbol=GEOMETRY_STATUS_SYMBOL
  [[ $UID = 0 || $EUID = 0 ]] && symbol+=_ROOT
  (( $GEOMETRY_LAST_STATUS )) && symbol+=_ERROR && color+=_ERROR

  [[ $GEOMETRY_LAST_STATUS != 0 && $GEOMETRY_STATUS_SHOW_CODE = true ]] && error_code="$GEOMETRY_STATUS_CODE_PREFIX$GEOMETRY_LAST_STATUS$GEOMETRY_STATUS_CODE_SUFFIX"
  ansi ${(P)color} "$error_code${(P)symbol}"
}
