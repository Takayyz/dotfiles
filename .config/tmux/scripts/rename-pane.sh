#!/bin/bash
# ペインタイトルをリネームする
# Usage: rename-pane.sh <pane_id>

pane_id="$1"
current_title=$(tmux display-message -t "$pane_id" -p '#{pane_title}')

printf "Pane title [%s]: " "$current_title"
read -r title

# 空入力の場合は現在のタイトルを維持
if [ -z "$title" ]; then
  exit 0
fi

tmux select-pane -t "$pane_id" -T "$title"
