alias cdx="codex resume"


CODEX_DUTY_DIR="$HOME/code/Duty-general"
function codex_duty() {
    PERSISTENT_TMP=$CODEX_DUTY_DIR mktmp $@
    codex
}
alias cdt="codex_duty"
alias cdtr="codex resume --cd $CODEX_DUTY_DIR"
