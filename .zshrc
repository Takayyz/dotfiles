#-----------------------------------------
# zpreztoの設定読み込み
#-----------------------------------------
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


#-----------------------------------------
# aliases
#-----------------------------------------
# 設定ファイルをどこからでもすぐ開く
alias -g zrc='~/.zshrc'
alias -g vrc='~/.vimrc'
#alias -g gvrc='~/.gvimrc'

#ls
alias l='ls -la'

# 設定即反映
alias sz='source ~/.zsh.d/.zshrc'

alias lg='lazygit'

# Preztoアップデート
alias preup='cd ~/.zprezto && git pull && git submodule update --init --recursive ; cd -'


#-----------------------------------------
# paths
#-----------------------------------------
# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# homebrewのphpを優先使用
# export PATH="/usr/local/opt/php@7.1/bin:$PATH"
# export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

#nodebrew
# export PATH=$HOME/.nodebrew/current/bin:$PATH

#android-studio
# export ANDROID_HOMNE=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDOROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools

# export EXPO_DEBUG=true


#-----------------------------------------
# others
#-----------------------------------------
# cd省略
setopt auto_cd

# 曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST

# cdしたあとで、自動的に ls する
function chpwd() { ls -la }

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
# [[ -f /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
# [[ -f /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
# [[ -f /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/takatoshihino/.nodebrew/node/v10.15.0/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh
