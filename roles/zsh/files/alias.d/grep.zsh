alias grep='rg'

rfz() {
    rg \
        --line-number \
        --no-heading \
        --color=always \
        --smart-case $@ | \
        fzf -d ':' \
        -n 2.. \
        --ansi --no-sort \
        --preview-window 'up:11:+{2}-5' \
        --preview 'bat --style=numbers --color=always --highlight-line {2} {1}'
}

