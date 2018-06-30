# Aliases

alias gocd="fastcd $GOPATH/src/ 3"
alias ancd="fastcd $HOME/dev/ansible 2"
alias docd="fastcd $HOME/dev/docker 1"

alias bur="bithookctl -p post -A uroboros uroboros"
alias urb='() { curl -d url=$1 uroboro.s/api/v1/tasks/ }'

alias gml="gometalinter --deadline 10s --config $HOME/.config/gometalinter.json ./..."

alias j="jobs"

function vimtemp() {
    tmpfile=`mktemp -t vimtmp-XXXXX`
    touch $tmpfile
    vim $tmpfile
}
alias vim-temp="vimtemp"

alias orgl='() { 
    project=$1
    group=$2
    shift 2
    orgalorg -o ~/.orgalorg/${project}/${group} -u e.persienko $@
}'


alias ssh="TERM=xterm && ssh"

# amfrex
alias amfrex-prod="amfrex -d _deployerd._tcp.s -h _heaverd-clusterd._tcp.production.s"

autoload smart-insert-last-word
bindkey "\e." smart-insert-last-word-wrapper
bindkey "\e," smart-insert-prev-word
zle -N smart-insert-last-word-wrapper
zle -N smart-insert-prev-word
function smart-insert-last-word-wrapper() {
    _altdot_reset=1
    smart-insert-last-word
}
function smart-insert-prev-word() {
    if (( _altdot_reset )); then
        _altdot_histno=$HISTNO
        (( _altdot_line=-_ilw_count ))
        _altdot_reset=0
        _altdot_word=-2
    elif (( _altdot_histno != HISTNO || _ilw_cursor != $CURSOR )); then
        _altdot_histno=$HISTNO
        _altdot_word=-1
        _altdot_line=-1
    else
        _altdot_word=$((_altdot_word-1))
    fi

    smart-insert-last-word $_altdot_line $_altdot_word 1

    if [[ $? -gt 0 ]]; then
        _altdot_word=-1
        _altdot_line=$((_altdot_line-1))
        smart-insert-last-word $_altdot_line $_altdot_word 1
    fi
}
