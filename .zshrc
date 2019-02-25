#-----------------------------------------
# zpreztoの設定読み込み
#-----------------------------------------

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


#-----------------------------------------
# alias
#-----------------------------------------

# 設定ファイルをどこからでもすぐ開く
alias -g zrc='~/.zshrc'
alias -g vrc='~/.vimrc'
#alias -g gvrc='~/.gvimrc'

#ls
alias l='ls -la'

# 設定即反映
alias sz='source ~/.zshrc'

# Preztoアップデート
alias preup='cd ~/.zprezto && git pull && git submodule update --init --recursive ; cd -'


#-----------------------------------------
# path
#-----------------------------------------

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# homebrewのphpを優先使用
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

#nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

#android-studio
export ANDROID_HOMNE=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDOROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export EXPO_DEBUG=true

#-----------------------------------------
# others
#-----------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls -a1 }
