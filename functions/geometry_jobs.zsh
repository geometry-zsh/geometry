# geometry_jobs - show background jobs count `⚙ 1`

function geometry_jobs { ansi ${GEOMETRY_JOBS_COLOR:=blue} '%(1j.'${GEOMETRY_JOBS_SYMBOL:="⚙"}' %j.)' }
