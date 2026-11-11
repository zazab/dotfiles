insert-next-word() { 
  # Tell `insert-last-word` to go forward (1), instead of backward (-1).
  zle insert-last-word -- 1 
}

# Create a widget that calls the function above.
zle -N insert-next-word

bindkey '^[.' insert-last-word
bindkey '^[,' insert-next-word

typeset -ga screen_word_candidates
typeset -gi screen_word_candidate
typeset -g screen_word_head
typeset -g screen_word_last_lbuffer screen_word_last_rbuffer

screen-word-complete() {
  [[ -n $TMUX_PANE ]] || { zle -M 'screen completion requires tmux'; return 1 }
  POSTDISPLAY=

  if (( !screen_word_candidate )) || [[ $LBUFFER != $screen_word_last_lbuffer || $RBUFFER != $screen_word_last_rbuffer ]]; then
    local prefix="${LBUFFER##*[[:space:]]}"
    screen_word_head="${LBUFFER[1,$(( ${#LBUFFER} - ${#prefix} ))]}"
    screen_word_candidates=(${(f)"$(tmux capture-pane -pF -t "$TMUX_PANE" | awk -v prefix="$prefix" '
      {
        flag = $1
        if (index(flag, "X")) input = NR
        sub(/^[^ ]+ /, "")
        if (!index(flag, "X")) lines[NR] = $0
      }
      END {
        for (line = input - 1; line; line--)
          for (word = split(lines[line], words); word; word--)
            if (index(words[word], prefix) == 1 && words[word] != prefix && !seen[words[word]]++)
              print words[word]
      }
    ')"})
    screen_word_candidate=0
  fi

  (( ${#screen_word_candidates} )) || { zle -M 'no screen completion'; return 1 }
  (( screen_word_candidate = screen_word_candidate % ${#screen_word_candidates} + 1 ))
  LBUFFER="${screen_word_head}${screen_word_candidates[screen_word_candidate]}"
  screen_word_last_lbuffer=$LBUFFER
  screen_word_last_rbuffer=$RBUFFER
}

zle -N screen-word-complete
bindkey '^[/' screen-word-complete

# alt-↑
bindkey '^[^[OA' insert-last-word
bindkey '^[^[[A' insert-last-word

# alt-↓
bindkey '^[^[OB' insert-next-word
bindkey '^[^[[B' insert-next-word

# autosuggestions
bindkey '^[s' autosuggest-toggle
bindkey '^L' forward-word
bindkey '^[L' forward-char
bindkey '^[[1;3C' forward-word
bindkey "^[[1;3D" backward-delete-word
