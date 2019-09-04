# Aliases

alias gml="gometalinter --deadline 10s --config $HOME/.config/gometalinter.json ./..."

function vimtemp() {
    tmpfile=`mktemp -t vimtmp-XXXXX`
    touch $tmpfile
    vim $tmpfile
}
alias vim-temp="vimtemp"
