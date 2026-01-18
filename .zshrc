export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh
alias v="NVIM_APPNAME=nvim ~/nightly-nvim/nvim-macos-arm64/bin/nvim"
alias vi="NVIM_APPNAME=nvim ~/nightly-nvim/nvim-macos-arm64/bin/nvim"
alias gs="git status"
alias gd="git diff"
alias m="open -a finder ."
alias l="ls -lah"

man() {
  v -c "tab Man $*" -c "tabo"
}

export PATH="$HOME/.local/bin:$PATH"
