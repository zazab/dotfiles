alias gu="git pull"
alias gul="git pull --rebase"
alias gf="git fetch"
#alias gp="git push"
#alias gpt="git push --tags"
#alias gpf="git push"
alias gd="git diff"
alias gcl="git clone"
alias ga="git add"
alias gi="git add -pi"
alias gl="git log --oneline --graph --decorate"
alias glb='() {
    base=${1:-master}
    start=$(git 2>/dev/null merge-base --fork-point $base || echo $base)
    git log --oneline --graph --decorate $start..HEAD
}'
alias gla="git log --oneline --graph --decorate --all"
alias gls="git log --graph --pretty=\"format:%C(auto)[%G?] %h%d %s\""
alias gs="git status -sb"
alias gignored="git check-ignore -v **/*"
#alias gco="git checkout"
