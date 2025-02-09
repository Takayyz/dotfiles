#-----------------------------------------
# exports
#-----------------------------------------
export XDG_CONFIG_HOME="$HOME/.config"

# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# historyコマンドのファイル指定
export HISTFILE="$ZDOTDIR/.zhistory"

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export ABBR_USER_ABBREVIATIONS_FILE="$ZDOTDIR/abbreviations"

#-----------------------------------------
# Plugin manager
#-----------------------------------------
# source command override technique
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}
ensure_zcompiled "$ZDOTDIR/.zshrc"

# sheldon cache technique
export SHELDON_CONFIG_DIR="$XDG_CONFIG_HOME/zsh/sheldon"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

zsh-defer unfunction source

#-----------------------------------------
# functions
#-----------------------------------------
# cdしたあとで、自動的にls
function chpwd() { eza $1 -algh --git --icons }
# ghqで選択したrepoへcd
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "bat --color=always --style=header,grid --line-range :50 $(ghq root)/{}/README.*")
  if [ -n "$src" ] ; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
function gs() {
  if [[ -n "$1" ]]; then
    git switch $1
    return
  fi

  git switch $(gb | fzf)
}

#-----------------------------------------
# key bindings
#-----------------------------------------
bindkey '^g' ghq-fzf

#-----------------------------------------
# others
#-----------------------------------------
# cd省略
setopt auto_cd
# beep音停止
setopt no_beep
setopt no_flow_control
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
# 大文字・小文字に関わらず補完を効かせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#-----------------------------------------
# Starship
#-----------------------------------------
# 設定読み込み
eval "$(starship init zsh)"

#-----------------------------------------
# direnv
#-----------------------------------------
eval "$(direnv hook zsh)"
