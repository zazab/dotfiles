alias dps="docker container ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.ID}}'"

alias di="docker image"
alias dvol="docker volume"
alias dn="docker node"
alias dnet="docker network"

alias dc="docker container"
alias dce="docker container exec -ti"

alias ds="docker stack"
alias dsrv="docker service"
alias doc="docker"

alias dm="docker-machine"
alias dme='() { eval $(docker-machine env $2 $1) }'

alias -g Jd='| docjq'
alias docjq='() { 
    sub=$1
    jq ".[]${sub}"
}'

