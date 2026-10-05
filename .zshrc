export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh
alias v="nvim"
alias gs="git status"
alias gd="git diff"
alias l="ls -lah"
alias za="zathura"
alias ncspot="flatpak run io.github.hrkfdn.ncspot"
alias ari="aria2c -c -s 16 -x 16"

man() {
  v -c "tab Man $*" -c "tabo"
}

# export PATH=$PATH:/usr/local/go/bin
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOPATH/bin
export PATH="$HOME/.local/bin:$PATH"
