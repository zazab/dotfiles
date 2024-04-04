#@IgnoreInspection BashAddShebang

init() {
  context=$(cat "$HOME/.kube/session_context" 2>/dev/null || echo "zeta")
  namespace=$(cat "$HOME/.kube/session_namespace" 2>/dev/null || echo "default")
  export k8s_namespace=$namespace
  export k8s_context=$context
  export k8s_session_aware=ON
  export k8s_debug=OFF
}

init

sakctl() {
  if [[ $k8s_debug == "ON" ]]; then
    set -x
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kctl_sa $@
    ret=$?
  else
    kubectl $@
    ret=$?
  fi

  if [[ $k8s_debug == "ON" ]]; then
    set +x
  fi
  return $ret
}

kctl_sa() {
    plugin=$1
    shift

    location=("--context" $k8s_context)
    if [[ "$k8s_namespace" != "" ]]; then
      location+=("--namespace" $k8s_namespace)
    fi

    kubectl $plugin $location $@
}

kenv() {
  echo -e "session aware: $k8s_session_aware"
  if [[ $k8s_debug == "ON" ]]; then
    echo -e "debug: ON"
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kenv_session_aware
  else
    kenv_raw
  fi
}

kenv_session_aware() {
  echo -e "context: $k8s_context\nnamespace: $k8s_namespace"
}

kenv_raw() {
  context=$(kubectl config current-context)
  namespace=$(kubectl config view -o json | jq -r ".contexts[] | select(.name == \"$context\") | .context.namespace")
  echo -e "context: $context\nnamespace: $namespace"
}

toggle_session_awareness() {
  if [[ $k8s_session_aware == "ON" ]]; then
    export k8s_session_aware=OFF
  else
    export k8s_session_aware=ON
  fi
}
alias ksa="toggle_session_awareness"

toggle_k8s_debug() {
  if [[ $k8s_debug == "ON" ]]; then
    export k8s_debug=OFF
  else
    export k8s_debug=ON
  fi
}
alias ktd="toggle_k8s_debug"

kube_set_context_sa() {
  kubectl config get-contexts $1 1>/dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "context $1 not found"
    return 1
  fi

  export k8s_context=$1
  echo $k8s_context >! "$HOME/.kube/session_context"
}

kube_set_context() {
  if [[ $k8s_session_aware == "ON" ]]; then
    kube_set_context_sa $@
  else
    kubectl config use-context $1
  fi

  kenv
}
alias ksc="kube_set_context"

kube_set_namespace_sa() {
  export k8s_namespace=$1
  echo $k8s_namespace >! "$HOME/.kube/session_namespace"
  return 0
}

kube_set_namespace_raw() {
  kubectl config set-context $(k config current-context) --namespace=$1
  ret=$?
  return $ret
}

kube_set_namespace() {
  namespace=$1

  if [[ $namespace == "" ]]; then
    namespace=default
  fi

  sakctl get namespace $namespace >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    echo "namespace $namespace not found"
    return 1
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kube_set_namespace_sa $namespace
  else
    kube_set_namespace_raw $namespace
  fi
  ret=$?

  kenv
  return $ret
}

alias ksn="kube_set_namespace"
alias ksnd="kube_set_namespace 'default'"

alias k="sakctl"
alias kl="sakctl logs"
alias kt="sakctl"
alias ke="sakctl exec -ti"

# get aliases
alias kgp="sakctl get po"
alias kgd="sakctl get deploy"
alias kgns="sakctl get ns"
alias kgn="sakctl get no"
alias kgn_taints="sakctl get no -o go-template-file=/Users/evpersienko/.kube/tpls/node_with_taints.tpl"
alias kgn_labels="sakctl get no -o go-template-file=/Users/evpersienko/.kube/tpls/node_with_labels.tpl"
alias kgn_cordon="sakctl get no -o go-template-file=/Users/evpersienko/.kube/tpls/node_cordon_reason.tpl | grep cordon"
alias kgs="sakctl get svc"
alias kgcm="sakctl get cm"
alias kgsec="sakctl get secret"
alias kgrs="sakctl get rs"
alias kgrb="sakctl get rolebinding"
alias kgro="sakctl get role"
alias kgcrb="sakctl get clusterrolebinding"
alias kgcro="sakctl get clusterrole"
alias kgcrd="sakctl get crd"
alias kgsa="sakctl get sa"
alias kgi="sakctl get ing"
alias kgds="sakctl get ds"
alias kge="sakctl get events --sort-by='{.lastTimestamp}'"
alias kge_nodes="sakctl get events --sort-by='{.lastTimestamp}' -A --field-selector 'involvedObject.kind=Node'"
alias kge_pods="sakctl get events --sort-by='{.lastTimestamp}' --field-selector='involvedObject.kind=Pod'"

alias kdp="sakctl describe po"
alias kdd="sakctl describe deploy"
alias kdn="sakctl describe no"
alias kdns="sakctl describe ns"
alias kds="sakctl describe svc"
alias kdcm="sakctl describe cm"
alias kdsec="sakctl describe secret"
alias kdrs="sakctl describe rs"
alias kdrb="sakctl describe rolebinding"
alias kdro="sakctl describe role"
alias kdcrb="sakctl describe clusterrolebinding"
alias kdcro="sakctl describe clusterrole"
alias kdcrd="sakctl describe crd"
alias kdsa="sakctl describe sa"
alias kdi="sakctl describe ing"
alias kdds="sakctl describe ds"


alias -g NAN="| grep -E 'NotReady|Disabled'"

alias -g CK="--context kappa"
alias -g KCK="--kube-context kappa"
alias -g CO="--context omega"
alias -g KCO="--kube-context omega"
alias -g CB="--context beta"
alias -g KCB="--kube-context beta"
alias -g CT="--context theta"
alias -g ANS="--all-namespaces"
alias -g WOnly="--watch --watch-only"
