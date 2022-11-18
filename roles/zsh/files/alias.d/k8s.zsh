#@IgnoreInspection BashAddShebang

alias ko="/Users/evpersienko/.avito/avito-cli-binaries/kubectl/kubectl_1.8"
alias k="kubectl"
alias kl="kubectl logs"
alias kt="kubetail"
alias ke="kubectl exec -ti"

# get aliases
alias kgp="kubectl get po"
alias kgd="kubectl get deploy"
alias kgns="kubectl get ns"
alias kgn="kubectl get no"
alias kgn_taints="kubectl get no -o go-template-file=/Users/evpersienko/.kube/tpls/node_with_taints.tpl"
alias kgn_labels="kubectl get no -o go-template-file=/Users/evpersienko/.kube/tpls/node_with_labels.tpl"
alias kgs="kubectl get svc"
alias kgcm="kubectl get cm"
alias kgsec="kubectl get secret"
alias kgrs="kubectl get rs"
alias kgrb="kubectl get rolebinding"
alias kgro="kubectl get role"
alias kgcrb="kubectl get clusterrolebinding"
alias kgcro="kubectl get clusterrole"
alias kgcrd="kubectl get crd"
alias kgsa="kubectl get sa"
alias kgi="kubectl get ing"
alias kgds="kubectl get ds"
alias kge='kubectl get events --sort-by='\''{.lastTimestamp}'\'

alias kdp="kubectl describe po"
alias kdd="kubectl describe deploy"
alias kdn="kubectl describe no"
alias kdns="kubectl describe ns"
alias kds="kubectl describe svc"
alias kdcm="kubectl describe cm"
alias kdsec="kubectl describe secret"
alias kdrs="kubectl describe rs"
alias kdrb="kubectl describe rolebinding"
alias kdro="kubectl describe role"
alias kdcrb="kubectl describe clusterrolebinding"
alias kdcro="kubectl describe clusterrole"
alias kdcrd="kubectl describe crd"
alias kdsa="kubectl describe sa"
alias kdi="kubectl describe ing"
alias kdds="kubectl describe ds"

kube_set_context() {
    context="$1"

    rm -f "$HOME/.kube/config"
    if [[ "$context" == "minikube" ]]; then
        cp "$HOME/.kube/config.minikube" "$HOME/.kube/config"
    else
        cp "$HOME/.kube/config.avito" "$HOME/.kube/config"
    fi

    kubectl config use-context $context
    #avito kubectl use-context $context
}
alias ksc="kube_set_context"

kube_sync_config() {
    set -x
    rm -f "$HOME/.kube/config"
    cp "$HOME/.kube/config.avito" "$HOME/.kube/config"
    avito kubectl sync-config
    rm -f "$HOME/.kube/config.avito"
    cp "$HOME/.kube/config" "$HOME/.kube/config.avito"
    set +x
}
alias ksync="kube_sync_config"

#alias ksc="avito kubectl use-context"

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

