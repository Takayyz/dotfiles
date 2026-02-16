#!/bin/bash
# Get git branch name for the given directory.
# Used by tmux window-status-current-format to show branch in active window.
# Usage: git-branch.sh <directory_path>

cd "$1" 2>/dev/null || exit 0

branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0

# U+E0B1 = Powerline thin right separator (UTF-8: 0xEE 0x82 0xB1)
# U+E0A0 = Nerd Font git branch icon (UTF-8: 0xEE 0x82 0xA0)
printf " \xee\x82\xb1 \xee\x82\xa0 %s " "$branch"
