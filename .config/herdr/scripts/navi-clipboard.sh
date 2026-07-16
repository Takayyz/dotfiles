#!/bin/bash
# navi --print で選択したコマンドをクリップボードにコピーし、herdr 経由で元の pane に送り込む
# ペーストは herdr pane send-text で行う（HERDR_ACTIVE_PANE_ID は popup の裏にある元 pane を指す）

cmd=$(navi --print)

if [ -n "$cmd" ]; then
  printf "%s" "$cmd" | pbcopy
  herdr pane send-text "$HERDR_ACTIVE_PANE_ID" "$cmd"
fi
