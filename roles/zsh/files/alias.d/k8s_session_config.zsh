kube_config_fork() {
  if [ -n "$KUBECONFIG" ]; then
    echo "kubeconfig already forked"
    return 1
  fi

  forked=$(mktemp -t kubeconfig-XXX)

  /bin/cp "${HOME}/.kube/config" "$forked"
  export "KUBECONFIG=$forked"

  echo "forked kubeconfig to ${forked}"
  return 0
}
alias kcfork="kube_config_fork"

kube_config_reset() {
  if [ -z "$KUBECONFIG" ]; then
    echo "kubeconfig already not forked"
    return 1
  fi

  rm -f "$KUBECONFIG"
  unset "KUBECONFIG"

  echo "kubeconfig reset to default"
  return 0
}
alias kcreset="kube_config_reset"

kube_config_refresh() {
  if [ -z "$KUBECONFIG" ]; then
    echo "kubeconfig is not forked"
    return 1
  fi

  rm -f "$KUBECONFIG"
  /bin/cp "${HOME}/.kube/config" "$KUBECONFIG"

  echo "kubeconfig updated from default"
  return 0
}
alias kcrefresh="kube_config_refresh"

kube_config_persist() {
  if [ -z "$KUBECONFIG" ]; then
    echo "kubeconfig is not forked"
    return 1
  fi

  /bin/cp "$KUBECONFIG" "${HOME}/.kube/config"

  echo "kubeconfig persisted to default"
  return 0
}
alias kcpersist="kube_config_persist"


