#-----------------------------------------
# tmux
#-----------------------------------------
if [[ -z "$TMUX" && -z "$VIM" && "$TERM_PROGRAM" != "vscode" && $- == *l* ]] ; then
  tmux attach-session -t default || tmux new-session -s default
fi

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
# VPN Connection setting
#-----------------------------------------
alias vpns='check_vpn_status'
alias vpnc='vpn_connect_with_fzf'
alias vpnd='vpn_disconnect_if_connected'

check_vpn_status() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Extract connected vpn.
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | "\(.name) (\(.status))"')

  if [[ -z "$connected_vpns" ]]; then
    echo "No Connected"
  else
    echo "Connected VPN:"
    echo "$connected_vpns"
  fi
}

vpn_connect_with_fzf() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Get the name and status of the VPN and select it with fzf.
  selected_vpn=$(echo "$vpn_data" | jq -r '.VPNs[] | "\(.name) (\(.status))"' | fzf --prompt="choose a vpn: ")
  selected_vpn=$(echo "$vpn_data" | jq -r '.VPNs[] | "\(.name) (\(.status))"' | fzf --tmux --prompt="choose a vpn: ")

  # If there is no selected VPN, exit
  if [[ -z "$selected_vpn" ]]; then
    echo "VPN selection canceled."
    return
  fi

  # Extract the vpn name
  vpn_name=$(echo "$selected_vpn" | sed 's/ (.*)//')

  # Connection place
  echo "connection: $vpn_name"
  vpnutil start "$vpn_name"
}

vpn_disconnect_if_connected() {
  # Extract the output of vpnutil list as json.
  vpn_data=$(vpnutil list)

  # Extract connected VPN
  connected_vpns=$(echo "$vpn_data" | jq -r '.VPNs[] | select(.status == "Connected") | .name')

  if [[ -z "$connected_vpns" ]]; then
    echo "No vpn connected."
  else
    echo "Disconnect the following VPN connections:"
    echo "$connected_vpns"

    # Turn off each connected VPN.
    for vpn in $connected_vpns; do
      echo "cutting: $vpn"
      vpnutil stop "$vpn"
    done
    echo "Disconnected all vpn connections."
  fi
}

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

  git switch $(git branch | fzf)
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
autoload -Uz compinit
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

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
