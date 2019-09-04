fzfcd-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N fzfcd-redraw-prompt

fzfcd() {
    #setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null

    local pattern=${1}
    shift

    local tmp_file=$(mktemp)
    local call_cwd=$(pwd)

    while [[ $# -gt 0 ]]
    do
        local search_path=${1}
        local maxdepth=${2}
        shift 2

        local abs_path=$search_path:A
        if [[ "$abs_path" != "$search_path" ]]; then # if not abs path
            abs_path="$call_cwd/$search_path"
            search_path=$abs_path:A
        fi

        cd $search_path
        fd $pattern -a --type d --exclude vendor --max-depth $maxdepth >> $tmp_file
    done

    local select=$(cat $tmp_file | fzf --reverse --height 50% --preview 'grc git -C {} status -sb 2>/dev/null || echo no git' --preview-window bottom:5)
    rm -rf $tmp_file

    cd $call_cwd
    if [[ -d "$select" ]]; then
        cd $select
        local exit_code=$?
        zle && fzfcd-redraw-prompt
        return $exit_code
    fi

    zle && zle redisplay
    return 0
}

function ccd fzfcd_code {
    fzfcd . $CODEHOME 1 $GOPATH/src 3
}
zle -N fzfcd_code
bindkey "\ed" fzfcd_code
bindkey -M "viopp" "\ed" fzfcd_code

function scd fzfcd_service {
    fzfcd 'service-*' $CODEHOME 1 $GOPATH/src/go.avito.ru 2
}
zle -N fzfcd_service
bindkey "\es" fzfcd_service
bindkey -M "viopp" "\es" fzfcd_service
