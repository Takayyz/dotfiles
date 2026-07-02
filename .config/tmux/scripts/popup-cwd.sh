#!/usr/bin/env bash
#
# popup-cwd.sh — resolve a tmux popup's working directory across a nested
# tmux -> herdr multiplexer setup, then exec the given command there.
#
# Why this exists:
#   tmux's #{pane_current_path} is the cwd of the pane's *foreground process*.
#   When that process is `herdr` (an inner multiplexer), tmux only sees herdr's
#   own cwd, not the shell the user is actually working in inside a herdr pane.
#   Popups launched with `-d #{pane_current_path}` therefore open in the wrong
#   directory (e.g. lazygit falls back to its repo picker).
#
#   In that case we ask the herdr server for the cwd of its focused pane. In a
#   plain tmux pane we just use the path tmux reports for the active pane.
#
# Note:
#   tmux does NOT expand #{...} format strings inside a `popup -E` command
#   string, so we must not receive them as arguments. Instead we query tmux
#   ourselves via `display-message`, which resolves against the pane that was
#   active when the popup opened (and which *does* expand formats).
#
# Usage:
#   popup-cwd.sh <command> [args...]

set -euo pipefail

pane_cmd=""
dir="$PWD"

if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
  pane_cmd="$(tmux display-message -p '#{pane_current_command}' 2>/dev/null || true)"
  pane_path="$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || true)"
  [ -n "$pane_path" ] && [ -d "$pane_path" ] && dir="$pane_path"
fi

# Only override when the active pane is running herdr; otherwise the path tmux
# reports is already correct and we avoid a needless socket round-trip.
if [ "$pane_cmd" = "herdr" ] && command -v herdr >/dev/null 2>&1; then
  focused_cwd="$(
    herdr pane list 2>/dev/null | python3 -c '
import sys, json
try:
    panes = json.load(sys.stdin)["result"]["panes"]
except Exception:
    sys.exit(0)
for p in panes:
    if p.get("focused"):
        print(p.get("cwd") or p.get("foreground_cwd") or "", end="")
        break
' 2>/dev/null || true
  )"
  if [ -n "$focused_cwd" ] && [ -d "$focused_cwd" ]; then
    dir="$focused_cwd"
  fi
fi

cd "$dir" || exit 1
exec "$@"
