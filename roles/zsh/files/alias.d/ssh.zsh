# blah.ru -> ssh blah.ru
# node.x  -> (resolve via search domain setting) ssh node
alias -s ru='ssh-helper "" .ru .ru "" ""'
alias -s x='ssh-helper "" .x "" "" ""'
alias -s s='ssh-helper "" .s "" "" "yes"'
alias -s uz='ssh-helper "" .uz ".sc.uz.internal" "" "yes"'
alias -s kz='ssh-helper "" .kz ".sc.kz.internal" "" "yes"'
alias -s sbc='ssh-helper "" .sbc ".sber.cloud.avito.ru" "" "yes"'


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
