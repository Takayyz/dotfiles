#-----------------------------------------
# zprezto
#-----------------------------------------
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Preztoアップデート
alias preup='cd ~/.zprezto && git pull && git submodule update --init --recursive ; cd -'

#-----------------------------------------
# aliases
#-----------------------------------------
# ls
alias l='exa --git --time-style=long-iso -agl'
alias lt='exa --icons -T -L 2 -a'

# 設定反映
alias sz="source ${HOME}/.zsh.d/.zshrc"
alias st="tmux source ${HOME}/.tmux.conf"

# lazygit
alias lg='lazygit'

# Git関連
alias gb='git branch'
alias gsw='git switch'
alias gsc='git switch -c'
alias gp='git pull'
alias gs='git status'
alias glg='git log --graph --abbrev-commit --date=format:"%Y-%m-%d %H:%M:%S(%a)" --pretty=format:"%C(yellow)commit %h%Creset %Cred%d%Creset%nCommitter: %Cblue%cn%Creset <%ce>%nDate:      %Cgreen%cd%Creset%n%n    %w(80)%s%Creset%n"'
alias glo='git log --oneline --pretty=format:"%Cred%h%Creset %Cgreen[%cd]%Creset %C(yellow)%d%Creset %s %Cblue<%cn>%Creset" --date=format:"%Y-%m-%d %H:%M:%S"'
alias glst='git log --stat
# ブランチ間の差分をコミット単位で確認 ex)glcd master..develop
alias glcd='git log --no-merges'

# viでvim起動
alias vi='vim'
# history実行時にコマンド実行日時表示
alias hist='history -i'
alias clock='tty-clock'

# Docker関連
alias dkc='docker compose'

# Volta関連
alias vla='volta list all'

#-----------------------------------------
# exports
#-----------------------------------------
# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# historyコマンドのファイル指定
export HISTFILE=${HOME}/.zsh.d/.zhistory

# nvm
export NVM_DIR=${HOME}/.nvm

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#-----------------------------------------
# others
#-----------------------------------------
# cdしたあとで、自動的に ls する
function chpwd() { l }
# cd省略
setopt auto_cd
# beep音停止
setopt no_beep
# 曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST
# historyに日付表示追加
setopt EXTENDED_HISTORY
# Change format of History command
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "
# historyコマンドをhistoryに入れない
unsetopt HIST_NO_STORE
autoload -U compinit
compinit -u
# 補完機能に色付け
autoload -U colors
colors
# 入力ワード無しの状態でTABの挿入阻止
zstyle ':completion:*' insert-tab false

#-----------------------------------------
# Starship
#-----------------------------------------
# 設定読み込み
eval "$(starship init zsh)"
