# ~/.zshrc

export EDITOR=nano
export PATH="$HOME/.asdf/bin:$PATH"

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Alias úteis
alias ll='ls -alF'
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gl='git log --oneline --graph --all'
