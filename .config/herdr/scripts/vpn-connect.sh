#!/usr/bin/env bash
# VPN connection selector for herdr popup
# Standalone copy of the tmux-era vpn_connect_with_fzf shell function (.config/zsh/.zshrc) —
# fzf's --tmux flag never opened a popup here since herdr panes have no $TMUX set.

set -euo pipefail

vpn_data=$(vpnutil list)

selected_vpn=$(echo "$vpn_data" | jq -r '.VPNs[] | "\(.name) (\(.status))"' | fzf --prompt="choose a vpn: ") || exit 0

if [[ -z "$selected_vpn" ]]; then
  echo "VPN selection canceled."
  exit 0
fi

vpn_name=$(echo "$selected_vpn" | sed 's/ (.*)//')

echo "connecting: $vpn_name"
vpnutil start "$vpn_name"

read -n 1 -s -r -p "Press any key to close..."
