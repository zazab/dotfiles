export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_USE_ASYNC="on"

bindkey '^[^?' autosuggest-clear
bindkey "\eS" autosuggest-toggle

