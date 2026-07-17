function mktmp() {
    local prefix created_dir

    prefix="$1"

    if [[ -z "$prefix" ]]; then
        prefix="generic-$(date -Idate)"
    fi

    created_dir=$(mktemp -d -p "${PERSISTENT_TMP-/tmp}" -t "$prefix")

    #dir="${HOME}/code/tmp/auto-erase/$(date -Iminutes)"

    echo "using ${created_dir}"
    #mkdir ${dir}
    cd "${created_dir}"
}

function codex_duty() {
    PERSISTENT_TMP=$HOME/code/Duty-general mktmp $@
    codex
}
