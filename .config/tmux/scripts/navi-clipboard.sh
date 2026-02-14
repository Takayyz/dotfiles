#!/bin/bash
# navi --print で選択したコマンドをクリップボードにコピーし、tmux buffer にセットする
# ペーストは tmux.conf 側の paste-buffer で行う

cmd=$(navi --print)

if [ -n "$cmd" ]; then
  printf "%s" "$cmd" | pbcopy
  tmux set-buffer -- "$cmd"
fi
