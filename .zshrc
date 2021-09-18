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
#ls
alias l='ls -la'
# 設定即反映
alias sz='source ~/.zsh.d/.zshrc'
# lazygit
alias lg='lazygit'
# Preztoアップデート
alias preup='cd ~/.zprezto && git pull && git submodule update --init --recursive ; cd -'
# Git関連
alias gs='git status'
alias glg='git log --graph --abbrev-commit --date=format:"%Y-%m-%d %H:%M:%S(%a)" --pretty=format:"%C(yellow)commit %h%Creset %Cred%d%Creset%nCommitter: %Cblue%cn%Creset <%ce>%nDate:      %Cgreen%cd%Creset%n%n    %w(80)%s%Creset%n"'
alias glo='git log --oneline --pretty=format:"%Cred%h%Creset %Cgreen[%cd]%Creset %C(yellow)%d%Creset %s %Cblue<%cn>%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
# ブランチ間の差分をコミット単位で確認 ex)glcd master..develop
alias glcd='git log --no-merges'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
# viでvim起動
alias vi='vim'
# history実行時にコマンド実行日時表示
alias hist='history -i'

#-----------------------------------------
# paths
#-----------------------------------------
# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
# historyコマンドのファイル指定
export HISTFILE=${HOME}/.zsh.d/.zhistory

#nodebrew
# export PATH=$HOME/.nodebrew/current/bin:$PATH

# nvm
export NVM_DIR=${HOME}/.nvm
## パスは環境毎に違うので環境に応じて書き換え
source /usr/local/Cellar/nvm/0.38.0/nvm.sh

#-----------------------------------------
# others
#-----------------------------------------
# cd省略
setopt auto_cd
# 曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST
# historyに日付表示追加
setopt EXTENDED_HISTORY
# Change format of History command
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "
#historyコマンドをhistoryに入れない
unsetopt HIST_NO_STORE
# cdしたあとで、自動的に ls する
function chpwd() { ls -la }
autoload -U compinit
compinit -u
# 補完機能に色付け
autoload -U colors
colors
# 入力ワード無しの状態でTABの挿入阻止
zstyle ':completion:*' insert-tab false

