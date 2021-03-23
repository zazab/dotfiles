# ssh aliases
alias -g U='sudo -i'
alias -g Z='zsh'

# 20.12.L -> ssh 192.168.20.12
# 20.12.P -> ssh 172.16.20.12
# t1.e    -> ssh ngs.ru.t1
# s.s     -> ssh s.s
# blah.ru -> ssh blah.ru
# node.p  -> ssh node.in.ngs.ru
# node.x  -> (resolve via search domain setting) ssh node
# alias -s L='ssh-helper 192.168. .L "" ""'
# alias -s P='ssh-helper 172.16. .P "" ""'
# alias -s e='ssh-helper ngs.ru. .e "" ""'
# alias -s s='ssh-helper "" .s .dev.ivi.ru ""'
# alias -s i='ssh-helper "" .i .dev.ivi.ru ""'
# alias -s n='ssh-helper "" .n .at.netstream.ru ""'
alias -s ru='ssh-helper "" .ru .ru "" ""'
# alias -s mk='ssh-helper "" .mk .epersienko.notkube.dev.ivi.ru ""'
# alias -s wk='ssh-helper "" .wk .epersienkowut.notkube.dev.ivi.ru ""'
# alias -s k='ssh-helper "" .k .notkube.dev.ivi.ru ""'
alias -s x='ssh-helper "" .x "" "" ""'
alias -s   s='ssh-helper "" .s "" "" "yes"'
# alias -s R='ssh-helper "" .R "" "root"'

function ssh-helper() {
    local prefix="$1"
    local remove_suffix="$2"
    local suffix="$3"
    local user="$4"
    local become="$5"
    local host="$6"
    shift 6

    pre_cmd=""
    if [ $become ]; then
        pre_cmd=$([ $# -gt 0 ] && echo "sudo " || echo "sudo -i")
    fi
    
    user_part=""
    if [ $user ]; then 
        user_part="$user@"
    fi

    #echo "TERM=xterm ssh -t $user_part$prefix\"${host%%$remove_suffix}\"$suffix \"${pre_cmd}${@}\""

    TERM=xterm ssh -t $user_part$prefix"${host%%$remove_suffix}"$suffix "${pre_cmd}${@}"
}

