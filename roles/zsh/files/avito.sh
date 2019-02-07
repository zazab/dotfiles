autoload -U +X bashcompinit && bashcompinit
source <(kubectl completion zsh)
source <(avito completion zsh)

source <(minikube docker-env)
