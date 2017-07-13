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
alias -s L='ssh-helper 192.168. .L "" ""'
alias -s P='ssh-helper 172.16. .P "" ""'
alias -s e='ssh-helper ngs.ru. .e "" ""'
alias -s s='ssh-helper "" .s .s ""'
alias -s ru='ssh-helper "" .ru .ru ""'
alias -s p='ssh-helper "" .p .in.ngs.ru ""'
alias -s x='ssh-helper "" .x "" ""'
alias -s R='ssh-helper "" .R "" "root"'

function ssh-helper() {
    local prefix="$1"
    local user="$4"
    local remove_suffix="$2"
    local suffix="$3"
    local host="$5"
    shift 5
    
    user_part=""
    if [ $user ]; then 
        user_part="$user@"
    fi

    TERM=xterm ssh -t $user_part$prefix"${host%%$remove_suffix}"$suffix "${@}"
}

