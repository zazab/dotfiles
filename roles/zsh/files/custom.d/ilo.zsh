get_ilo_ip() {
    node="$1"
    ilo_ip=$(dig $node.admin.msk.avito.ru +noall +answer | tail -n 1 | awk '{print $5}')
    if [ -z "$ilo_ip" ]; then
        return 1
    fi

    echo $ilo_ip
    return 0
}

get_metal_id() {
    ip="$1"

    out=$(infra metal device list -o json)
    metal_id=$(echo "$out" | jq 2>/dev/null --arg ipmi_ip "$ip" -r '.[] | select(.ipmi_ip == $ipmi_ip) | .id')
    #metal_id=$(infra metal device list | grep -i "$ip" | awk '{ print $1 }')
    if [ -z "$metal_id" ]; then
        echo "$out" >&2
        return 1
    fi

    echo $metal_id
    return 0
}

get_metal_id_by_name() {
    node="$1"

    log_debug "getting ilo ip for $node"
    ilo_ip=$(get_ilo_ip $node)
    log_debug "got ilo ip for $node: $ilo_ip"
    if [ -z "ilo_ip" ]; then
        return 1
    fi

    log_debug "getting metal id for $node"
    metal_id=$(get_metal_id $ilo_ip)
    log_debug "got metal id for $node: $metal_id"
    if [ -z "$metal_id" ]; then
        return 1
    fi

    echo $metal_id
    return 0
}

get_ilo_cred() {
    node="$1"

#    ilo_ip=$(get_ilo_ip $node)
#    if [ -z "$ilo_ip" ]; then
#        log_error "ilo_ip not found for $node"
#        return 1
#    fi
#
#    metal_id=$(get_metal_id $ilo_ip)
#    if [ -z "$metal_id" ]; then
#        log_error "metal ID not found for $node"
#        return 1
#    fi

    creds=$(infra metal device credentials "$node")
    if [[ $? -ne 0 ]]; then
        echo "can't find creds for $node"
        return 1
    fi

    login=$(echo "$creds" | grep "login" | awk '{ print $2 }')
    password=$(echo "$creds" | grep "password" | awk '{ print $2 }')

    echo "$password" | pbcopy
    echo "login $login, password copied"
}

alias creds="get_ilo_cred"
open_ilo() {
    get_ilo_cred $1
    ret=$?

    if [ $ret -ne 0 ]; then
        return 1
    fi

    echo "opening ilo"
    sleep 2
    open "https://$node.admin.msk.avito.ru"
}

alias ilo="open_ilo"