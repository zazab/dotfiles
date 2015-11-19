source ~/.zprofile

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=~/.zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="vim-blinks"
#ZSH_THEME="crunch"
#ZSH_THEME="fletcherm"
#ZSH_THEME="agnoster"
ZSH_THEME="norm"


CHASE_DOTS="true"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git history-substring-search safe-paste rails knife golang pip colored-man)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=^[[7~
key[End]=^[[8~
key[Insert]=^[[2~
key[Delete]=^[[3~

# setup key accordingly
bindkey  "^[[7~"  beginning-of-line
bindkey  "^[[8~"  end-of-line
bindkey  "^[[2~"  overwrite-mode
bindkey  "^[[3~"  delete-char
bindkey  "^[Od"   backward-word
bindkey  "^[Oc"   forward-word

path+=("$GOPATH/bin")
path+=("$HOME/.gem/ruby/2.1.0/bin")
export PATH

source $ZSH_CUSTOM/aliases.sh

eval `dircolors ~/.dircolors`

stty -ixon
