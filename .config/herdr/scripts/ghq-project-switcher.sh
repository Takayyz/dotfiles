#!/usr/bin/env bash
#
# ghq-project-switcher.sh (herdr版)
# fzf で ghq 管理のリポジトリを選択し、herdr の新しい workspace で開く
#

set -euo pipefail

selected=$(ghq list | fzf \
  --prompt="Select project > " \
  --preview "bat --color=always --style=header,grid --line-range :50 $(ghq root)/{}/README.* 2>/dev/null || echo 'No README found'" \
) || exit 0

if [ -n "$selected" ]; then
  target_dir="$(ghq root)/$selected"
  herdr workspace create --cwd "$target_dir" --label "$(basename "$selected")" --focus
fi
