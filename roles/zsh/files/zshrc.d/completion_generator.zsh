function refreshCompletions() {
  generator_path=~/.zsh/completion_generators
  generated_path=~/.zsh/generated_completions.d
  for generator in "$generator_path"/*.zsh; do
      file=$(basenam)
      completion_name="${file%.zsh}"
      $generator > "$generated_path/${completion_name}_completion.zsh"
  done
}
