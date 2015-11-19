# Aliases
# Color aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Other aliases
alias -g M='|more'
alias -g L='|less'
alias -g H='|head'
alias -g T='|tail'
alias -g N='2>/dev/null'
alias -g G='|grep'
alias -g GO='|grep -o'
alias -g SU='| sort | uniq'

alias ping="grc ping"
alias traceroute="grc traceroute"
alias make="grc make"
alias diff="grc diff"
alias cvs="grc cvs"
alias netstat="grc netstat"
alias logc="grc cat"
alias logt="grc tail"
alias logh="grc head"

# Chef aliases
alias kc="knife cookbook"
alias kcl="knife client"
alias kd="knife data bag"
alias ke="knife environment"
alias kn="knife node"
alias kr="knife role"
alias cuv="cat ~/dev/chef/cookbooks/version"

# Git aliases
alias gp="git push"
alias gpl="git pull --rebase"
alias gf="git fetch"
alias gp="git push"
alias gpt="git push --tags"
alias gcl="git clone"
alias ga="git add"
alias gi="git add -pi"
alias gl="git log --oneline --graph --decorate --all"
alias gs="git status -sb"
alias gco="git checkout"

#alias ssh="TERM=rxvt-unicode && ssh"
#alias -g Z="-t zsh"

zssh () { TERM=rxvt-unicode && ssh $1 -t "zsh || bash"}
alias ssh="TERM=rxvt-unicode && ssh"

# ctls
alias sctl="systemctl"
alias jctl="journalctl"

alias sudo="sudo "
#alias heaverc="ssh -q chef -t heaverc"
alias heavercdev="heaverc --config /etc/heaver/client-dev.yml"
alias less="vimpager"
alias vims="vim --servername Vim"

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

# batrak aliases
alias bk="batrak -LK"
alias bl="batrak -L"
alias bs="batrak -Sn"
alias bt="batrak -Tn"
alias ba="batrak -An"
alias bm="batrak -Mn"
alias bC="batrak -Cn"
