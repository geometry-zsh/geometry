# mnml_jobs - show background jobs count `⚙ 1`

mnml_jobs() {  [[ 0 -ne "$(jobs | wc -l)" ]] && ansi ${MNML_JOBS_COLOR:=blue} '%(1j.'${MNML_JOBS_SYMBOL:="⚙"}' %j.)'; }
