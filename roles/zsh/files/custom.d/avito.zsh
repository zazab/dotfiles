autoload -U +X bashcompinit && bashcompinit

export PIP_INDEX_URL=http://pypi.k.avito.ru/pypi/
export PIP_TRUSTED_HOST=pypi.k.avito.ru
export PIP_EXTRA_INDEX_URL=https://pypi.org/pypi/

export VAULT_ADDR="https://active.vault.service.avito:8200"
export VAULT_CACERT=/Users/evpersienko/.avito/certs/root_rsa_2025.crt

export GONOPROXY="go.avito.ru"
export GONOSUMDB="go.avito.ru"

export TILLER_NAMESPACE="tiller"

ru_vault() {
    echo "Switching to RU-vault"
    export VAULT_ADDR="https://active.vault.service.avito:8200"
    #export VAULT_CACERT=/Users/evpersienko/.avito/avito_ca.crt
}

uz_vault() {
    echo "Switching to UZ-vault"
    export VAULT_ADDR=https://vault-uz-01.sc.uz.internal:8200
    #export VAULT_CACERT=/Users/evpersienko/.avito/certs/root_rsa_2025.crt
}
