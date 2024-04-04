insert-next-word() { 
  # Tell `insert-last-word` to go forward (1), instead of backward (-1).
  zle insert-last-word -- 1 
}

# Create a widget that calls the function above.
zle -N insert-next-word

bindkey '^[.' insert-last-word
bindkey '^[;' insert-next-word

# alt-↑
bindkey '^[^[OA' insert-last-word
bindkey '^[^[[A' insert-last-word

# alt-↓
bindkey '^[^[OB' insert-next-word
bindkey '^[^[[B' insert-next-word
