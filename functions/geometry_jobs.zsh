# geometry_jobs - show background jobs count

function geometry_jobs {
  : ${GEOMETRY_JOBS_COLOR:=blue}
  : ${GEOMETRY_JOBS_SYMBOL:="⚙"}

  [[ $(print -P '%j') == "0" ]] || return
  local jobs_prompt='%(1j.'$GEOMETRY_JOBS_SYMBOL' %j.)'
  ansi $GEOMETRY_JOBS_COLOR $jobs_prompt
}
