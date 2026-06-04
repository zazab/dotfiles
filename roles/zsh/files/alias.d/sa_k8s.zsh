init() {
  context=$(cat "$HOME/.kube/session_context" 2>/dev/null || echo "zeta")
  namespace=$(cat "$HOME/.kube/session_namespace" 2>/dev/null || echo "default")
  export k8s_namespace=$namespace
  export k8s_context=$context
  export k8s_session_aware=ON
  export k8s_debug=OFF
}

init

current_context () {
  if [[ $k8s_session_aware == "ON" ]]; then
    echo $k8s_context
  else
    kubectl config current-context
  fi
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

fzf_app_context_selector() {
  query="$1"

  yq '.contexts[] | .name + ";" + .description + ";" + .kube + ";" + .namespace' < "$HOME/.kube/app_contexts.yaml" | \
  fzf \
    -d ';' \
    --accept-nth 1 \
    --query "$query" \
    --select-1 \
    --preview-window 'down:4' \
    --with-nth '{1} - {2}' \
    --preview-label 'App Context Info' \
    --preview "echo '# {1}\n==========\ncluster: {3}\nnamespace: {4}'"
}

kube_set_app_context() {
  query=$1

  if [ -z "$query" ]; then
    context=$(fzf_app_context_selector)
  else
    yq ".contexts[] | select(.name == \"$query\")" < "$HOME/.kube/app_contexts.yaml"

    if [[ $? -ne 0 ]]; then
      context=$(fzf_app_context_selector "$query")
    else
      context=$query
    fi
  fi

  if [ -z "$context" ]; then
    echo "Context not selected, cancel"
    return
  fi

  meta=$(cat $HOME/.kube/app_contexts.yaml | yq ".contexts[] | select(.name == \"$context\")")

  kube=$(echo "$meta" | yq '.kube')
  namespace=$(echo "$meta" | yq '.namespace')

  k8s_sa_silent=TRUE kube_set_context $kube
  k8s_sa_silent=TRUE kube_set_namespace $namespace

  kenv
}
alias ksac=kube_set_app_context

fzf_context_selector () {
  sakctl config get-contexts -o name | \
  fzf \
      --query "$query" \
      --select-1 \
      --preview-window 'down:50%' \
      --preview-label 'Cluster Info' \
      --preview 'describe_cluster {1}'
}

kube_set_context() {
  query="$1"

  if [ -z "$query" ]; then
    context=$(fzf_context_selector)
  else
    sakctl config get-contexts -o name $query >/dev/null 2>&1

    if [[ $? -ne 0 ]]; then
      context=$(fzf_context_selector $query)
    else
      context=$query
    fi
  fi

  if [ -z "$context" ]; then
    echo "Context not selected, cancel"
    return
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kube_set_context_sa $context
  else
    kubectl config use-context $context
  fi

  if [[ $k8s_sa_silent != "TRUE" ]]; then
    kenv
  fi
}
alias ksc="kube_set_context"

kube_set_namespace_sa() {
  export k8s_namespace=$1
  echo $k8s_namespace >! "$HOME/.kube/session_namespace"
  return 0
}

kube_set_namespace_raw() {
  kubectl config set-context "$(kubectl config current-context)" --namespace=$1
  ret=$?
  return $ret
}

fzf_ns_selector() {
  query="$1"

  context=$(current_context)

  ns_cache="$HOME/.kube/cache/ns/$context.json"

  if [ ! -f "$ns_cache" ]; then
    echo "no ns in cache, updating"
    sakctl get ns -o json > "$ns_cache"
    wc -l $ns_cache
  fi

  jq -r '.items[].metadata.name' < $ns_cache | \
  fzf \
    --query "$query" \
    --select-1 \
    --preview-window 'down:4' \
    --preview-label 'Namespace info' \
    --header "Namespaces in $context @ $(date -Iminutes -r $ns_cache); ctrl+r to update" \
    --bind "ctrl-r:reload(sakctl get ns -o json | tee $ns_cache | jq -r '.items[].metadata.name')" \
    --preview 'describe_ns {1}'
}

kube_set_namespace() {
  query="$1"

  if [ -z "$query" ]; then
    namespace=$(fzf_ns_selector)
  else
    sakctl get namespace $query >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      namespace=$(fzf_ns_selector $query)
    else
      namespace=$query
    fi
  fi

  if [ -z "$namespace" ]; then
    echo "no namespace selected, cancel"
    return 1
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

  if [[ $k8s_sa_silent != "TRUE" ]]; then
    kenv
  fi
  return $ret
}
alias ksn="kube_set_namespace"
alias ksnd="kube_set_namespace 'default'"

kube_push_context() {
  echo $k8s_namespace >! "$HOME/.kube/session_namespace"
  echo $k8s_context >! "$HOME/.kube/session_context"

  kenv
}
alias kcpush=kube_push_context

kube_pop_context() {
  context=$(cat "$HOME/.kube/session_context" 2>/dev/null || echo "zeta")
  namespace=$(cat "$HOME/.kube/session_namespace" 2>/dev/null || echo "default")
  export k8s_namespace=$namespace
  export k8s_context=$context

  kenv
}
alias kcpop=kube_pop_context

kube_save_app_context() {
  read "ctx_name?enter app context name: "
  read "ctx_description?enter app context description: "

  context=$(echo -e -n "- name: $ctx_name\n  kube: $k8s_context\n  namespace: $k8s_namespace\n  description: $ctx_description")
  echo $context | yq

  if read -q "choice?Save? [y/n] "; then
    echo "\nSaving..."
    echo "$context" | yq >> $HOME/.kube/app_contexts.yaml
  else
    echo "\nAbort..."
  fi
}