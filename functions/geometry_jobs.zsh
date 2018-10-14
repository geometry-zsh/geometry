# geometry_jobs - show background jobs count

: ${GEOMETRY_JOBS_COLOR:=blue}
: ${GEOMETRY_JOBS_SYMBOL:="⚙"}

function geometry_jobs {
  [[ $(print -P '%j') == "0" ]] || return
  local jobs_prompt='%(1j.'$GEOMETRY_JOBS_SYMBOL' %j.)'
  echo $(color $GEOMETRY_JOBS_COLOR $jobs_prompt)
}
