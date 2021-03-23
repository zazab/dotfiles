#!/usr/bin/env zsh

base=$(dirname $0)
yaml="${base}/strap_configs.yaml"

ansible-playbook -c local -i localhost, $yaml -t zsh -e home=$HOME --diff "$@"