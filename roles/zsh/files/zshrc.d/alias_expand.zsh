globalias() {
    if [[ $LBUFFER =~ \ [A-Z]+$ ]]; then
        zle _expand_alias
        zle expand-word
    fi
    zle self-insert
}
zle -N globalias

force_expand() {
    zle _expand_alias
    zle expand-word
    zle self-insert
}
zle -N force_expand

bindkey -M viins " " globalias
bindkey -M viins "^[ " force_expand
bindkey -M viins "^[[Z" magic-space
bindkey -M isearch " " magic-space
