#!/usr/bin/env bash
#
# ghq-project-switcher.sh
# fzf で ghq 管理のリポジトリを選択し、新しい tmux ウィンドウで開く
#

set -euo pipefail

selected=$(ghq list | fzf \
  --prompt="Select project > " \
  --preview "bat --color=always --style=header,grid --line-range :50 $(ghq root)/{}/README.* 2>/dev/null || echo 'No README found'" \
) || exit 0

if [ -n "$selected" ]; then
  target_dir="$(ghq root)/$selected"
  tmux new-window -a -c "$target_dir"
fi
