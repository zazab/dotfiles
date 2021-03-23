#@IgnoreInspection BashAddShebang

alias ko="/Users/evpersienko/.avito/avito-cli-binaries/kubectl/kubectl_1.8"
alias k="kubectl"
alias kl="kubectl logs"
alias kt="kubetail"
alias ke="kubectl exec -ti"
alias kgp="kubectl get po"
alias kgdpl="kubectl get deploy"
alias kgns="kubectl get ns"
alias kdp="kubectl describe po"
alias kgn="kubectl get no"
alias kdn="kubectl describe no"
alias kge='kubectl get events --sort-by='\''{.lastTimestamp}'\'

alias ksc="avito kubectl use-context"

kube_set_namespace() {
    kubectl get namespace $1 > /dev/null;
    if [ $? -eq 1 ]; then
        return $?
    fi

    kubectl config set-context $(k config current-context) --namespace=$1
    echo "Namespace: $1"
    return 0
}

alias ksn="kube_set_namespace"
alias ksnd="kube_set_namespace ''"

alias -g NAN="| grep -E 'NotReady|Disabled'"

alias -g CK="--context kappa"
alias -g KCK="--kube-context kappa"
alias -g CO="--context omega"
alias -g KCO="--kube-context omega"
alias -g CB="--context beta"
alias -g KCB="--kube-context beta"
alias -g CT="--context theta"
alias -g ANS="--all-namespaces"

