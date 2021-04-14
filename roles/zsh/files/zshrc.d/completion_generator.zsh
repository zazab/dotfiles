generator_path="$HOME/.zsh/completion_generators"
generated_path="$HOME/.zsh/generated_completions.d"

function refreshCompletions() {
  for generator in "$generator_path"/*.zsh; do
      file=$(basename $generator)
      completion_name="${file%.zsh}"
      $generator >! "$generated_path/${completion_name}_completion.zsh"
  done

  loadCompletions
}

function loadCompletions() {
  for comp in "$generated_path"/*.zsh; do
      source "$comp"
  done
}
