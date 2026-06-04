k8s_session_init() {
  local context namespace

  mkdir -p "$HOME/.kube"

  context=$(cat "$HOME/.kube/session_context" 2>/dev/null || echo "${K8S_DEFAULT_CONTEXT:-zeta}")
  namespace=$(cat "$HOME/.kube/session_namespace" 2>/dev/null || echo "${K8S_DEFAULT_NAMESPACE:-default}")
  export k8s_namespace="$namespace"
  export k8s_context="$context"
  export k8s_session_aware=ON
  export k8s_debug=OFF
}

k8s_session_init

current_context () {
  if [[ $k8s_session_aware == "ON" ]]; then
    echo "$k8s_context"
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
  local context namespace

  context=$(kubectl config current-context)
  namespace=$(kubectl config view -o json | KUBE_CONTEXT="$context" jq -r '.contexts[] | select(.name == env.KUBE_CONTEXT) | .context.namespace')
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
  kubectl config get-contexts "$1" 1>/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "context $1 not found"
    return 1
  fi

  mkdir -p "$HOME/.kube"
  export k8s_context="$1"
  echo "$k8s_context" >! "$HOME/.kube/session_context"
}

k8s_app_contexts_file() {
  echo "$HOME/.kube/app_contexts.json"
}

ensure_app_contexts_file() {
  local app_contexts_file

  app_contexts_file=$(k8s_app_contexts_file)
  mkdir -p "$(dirname "$app_contexts_file")"

  if [[ ! -f "$app_contexts_file" ]]; then
    jq -n '{contexts: []}' >! "$app_contexts_file"
    return $?
  fi

  jq -e '.contexts | arrays' < "$app_contexts_file" >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "invalid app contexts file: $app_contexts_file"
    return 1
  fi
}

fzf_app_context_selector() {
  local app_contexts_file
  local query="$1"

  ensure_app_contexts_file || return $?
  app_contexts_file=$(k8s_app_contexts_file)

  jq -r '.contexts[] | [.name, .description, .kube, .namespace] | @tsv' < "$app_contexts_file" | \
  fzf \
    -d '\t' \
    --accept-nth 1 \
    --query "$query" \
    --select-1 \
    --preview-window 'down:4' \
    --with-nth '{1} - {2}' \
    --preview-label 'App Context Info' \
    --preview "echo '# {1}\n==========\ncluster: {3}\nnamespace: {4}'"
}

kube_set_app_context() {
  local app_contexts_file context kube meta namespace query

  query="$1"
  ensure_app_contexts_file || return $?
  app_contexts_file=$(k8s_app_contexts_file)

  if [[ -z "$query" ]]; then
    context=$(fzf_app_context_selector)
  else
    jq -e --arg query "$query" '.contexts[]? | select(.name == $query)' < "$app_contexts_file" >/dev/null 2>&1

    if [[ $? -ne 0 ]]; then
      context=$(fzf_app_context_selector "$query")
    else
      context=$query
    fi
  fi

  if [[ -z "$context" ]]; then
    echo "Context not selected, cancel"
    return
  fi

  meta=$(jq --arg context "$context" '.contexts[] | select(.name == $context)' < "$app_contexts_file")

  kube=$(echo "$meta" | jq -r '.kube')
  namespace=$(echo "$meta" | jq -r '.namespace')

  k8s_sa_silent=TRUE kube_set_context "$kube" || return $?
  k8s_sa_silent=TRUE kube_set_namespace "$namespace" || return $?

  kenv
}
alias ksac=kube_set_app_context

fzf_context_selector () {
  local query="$1"

  sakctl config get-contexts -o name | \
  fzf \
      --query "$query" \
      --select-1 \
      --preview-window 'down:50%' \
      --preview-label 'Cluster Info' \
      --preview 'describe_cluster {1}'
}

kube_set_context() {
  local context query ret

  query="$1"

  if [[ -z "$query" ]]; then
    context=$(fzf_context_selector)
  else
    sakctl config get-contexts -o name "$query" >/dev/null 2>&1

    if [[ $? -ne 0 ]]; then
      context=$(fzf_context_selector "$query")
    else
      context=$query
    fi
  fi

  if [[ -z "$context" ]]; then
    echo "Context not selected, cancel"
    return
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kube_set_context_sa "$context"
  else
    kubectl config use-context "$context"
  fi
  ret=$?

  if [[ $ret -eq 0 && $k8s_sa_silent != "TRUE" ]]; then
    kenv
  fi
  return $ret
}
alias ksc="kube_set_context"

kube_set_namespace_sa() {
  mkdir -p "$HOME/.kube"
  export k8s_namespace="$1"
  echo "$k8s_namespace" >! "$HOME/.kube/session_namespace"
  return 0
}

kube_set_namespace_raw() {
  local ret

  kubectl config set-context "$(kubectl config current-context)" --namespace="$1"
  ret=$?
  return $ret
}

fzf_ns_selector() {
  local context ns_cache ns_cache_updated_at query

  query="$1"
  context=$(current_context)

  ns_cache="$HOME/.kube/cache/ns/$context.json"
  mkdir -p "$(dirname "$ns_cache")"

  if [[ ! -f "$ns_cache" ]]; then
    sakctl get ns -o json > "$ns_cache" || return $?
  fi

  ns_cache_updated_at=$(date -r "$ns_cache" '+%Y-%m-%dT%H:%M:%S%z')

  jq -r '.items[].metadata.name' < "$ns_cache" | \
  fzf \
    --query "$query" \
    --select-1 \
    --preview-window 'down:4' \
    --preview-label 'Namespace info' \
    --header "Namespaces in $context @ $ns_cache_updated_at; ctrl+r to update" \
    --bind "ctrl-r:reload(sakctl get ns -o json | tee \"$ns_cache\" | jq -r '.items[].metadata.name')" \
    --preview 'describe_ns {1}'
}

kube_set_namespace() {
  local namespace query ret

  query="$1"

  if [[ -z "$query" ]]; then
    namespace=$(fzf_ns_selector)
  else
    sakctl get namespace "$query" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      namespace=$(fzf_ns_selector "$query")
    else
      namespace=$query
    fi
  fi

  if [[ -z "$namespace" ]]; then
    echo "no namespace selected, cancel"
    return 1
  fi

  sakctl get namespace "$namespace" >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    echo "namespace $namespace not found"
    return 1
  fi

  if [[ $k8s_session_aware == "ON" ]]; then
    kube_set_namespace_sa "$namespace"
  else
    kube_set_namespace_raw "$namespace"
  fi
  ret=$?

  if [[ $ret -eq 0 && $k8s_sa_silent != "TRUE" ]]; then
    kenv
  fi
  return $ret
}
alias ksn="kube_set_namespace"
alias ksnd="kube_set_namespace 'default'"

kube_push_context() {
  mkdir -p "$HOME/.kube"
  echo "$k8s_namespace" >! "$HOME/.kube/session_namespace"
  echo "$k8s_context" >! "$HOME/.kube/session_context"

  kenv
}
alias kcpush=kube_push_context

kube_pop_context() {
  local context namespace

  context=$(cat "$HOME/.kube/session_context" 2>/dev/null || echo "${K8S_DEFAULT_CONTEXT:-zeta}")
  namespace=$(cat "$HOME/.kube/session_namespace" 2>/dev/null || echo "${K8S_DEFAULT_NAMESPACE:-default}")
  export k8s_namespace="$namespace"
  export k8s_context="$context"

  kenv
}
alias kcpop=kube_pop_context

kube_save_app_context() {
  local app_contexts_file context ctx_description ctx_name tmp_file

  read "ctx_name?enter app context name: "
  read "ctx_description?enter app context description: "

  ensure_app_contexts_file || return $?
  app_contexts_file=$(k8s_app_contexts_file)

  jq -e --arg name "$ctx_name" '.contexts[]? | select(.name == $name)' < "$app_contexts_file" >/dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    echo "app context $ctx_name already exists"
    return 1
  fi

  context=$(jq -n --arg name "$ctx_name" --arg kube "$k8s_context" --arg namespace "$k8s_namespace" --arg description "$ctx_description" '{name: $name, kube: $kube, namespace: $namespace, description: $description}')
  echo "$context"

  if read -q "choice?Save? [y/n] "; then
    echo "\nSaving..."
    tmp_file="${app_contexts_file}.tmp"
    jq --arg name "$ctx_name" --arg kube "$k8s_context" --arg namespace "$k8s_namespace" --arg description "$ctx_description" '.contexts += [{"name": $name, "kube": $kube, "namespace": $namespace, "description": $description}]' "$app_contexts_file" >! "$tmp_file" && mv "$tmp_file" "$app_contexts_file"
  else
    echo "\nAbort..."
  fi
}
