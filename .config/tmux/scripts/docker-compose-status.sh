#!/bin/bash
# Docker Compose status viewer for tmux popup
# Shows `docker compose ps` with auto-refresh and Iceberg-themed coloring,
# or a message if no compose file is found.

# Iceberg color scheme (256-color for watch compatibility)
BLUE=$'\033[38;5;146m'    # #84a0c6 - header
GREEN=$'\033[38;5;187m'   # #b4be82 - running (Up)
RED=$'\033[38;5;174m'     # #e27878 - exited/dead
CYAN=$'\033[38;5;152m'    # #89b8c2 - title
DIM=$'\033[38;5;103m'     # #6b7089 - dim text
ORANGE=$'\033[38;5;180m'  # #e2a478 - created/paused
RESET=$'\033[0m'

# Render mode: output colorized docker compose ps (called by watch)
if [ "$1" = "--render" ]; then
  project_name=$(basename "$(pwd)")
  echo "${CYAN} Docker Compose Status${RESET}  ${DIM}(${project_name})${RESET}"
  echo "${DIM} Ctrl+C to close | Refreshing every 2s${RESET}"
  echo ""

  docker compose ps --format table 2>/dev/null | awk '
    BEGIN {
      ESC = sprintf("%c", 27)
      blue   = ESC "[1;38;5;146;48;5;235m"
      green  = ESC "[38;5;187m"
      red    = ESC "[38;5;174m"
      orange = ESC "[38;5;180m"
      reset  = ESC "[0m"
    }
    NR==1 { print blue $0 reset; next }
    /Up /         { gsub(/Up/,          green  "Up"          reset); print; next }
    /Exited/      { gsub(/Exited/,      red    "Exited"      reset); print; next }
    /Dead/        { gsub(/Dead/,        red    "Dead"        reset); print; next }
    /Restarting/  { gsub(/Restarting/,  red    "Restarting"  reset); print; next }
    /Created/     { gsub(/Created/,     orange "Created"     reset); print; next }
    /Paused/      { gsub(/Paused/,      orange "Paused"      reset); print; next }
    { print }
  '
  exit 0
fi

# --- Main: find compose file and launch watch ---

find_compose_dir() {
  local dir="$1"
  local home="$HOME"
  local files=("compose.yml" "compose.yaml" "docker-compose.yml" "docker-compose.yaml")

  while true; do
    for f in "${files[@]}"; do
      if [ -f "$dir/$f" ]; then
        echo "$dir"
        return 0
      fi
    done
    # Stop at home directory
    if [ "$dir" = "$home" ] || [ "$dir" = "/" ]; then
      return 1
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

compose_dir=$(find_compose_dir "$(pwd)")

if [ -n "$compose_dir" ]; then
  cd "$compose_dir" || exit 1
  watch -n 2 -t --color "$0 --render"
else
  clear
  echo ""
  echo "  ${RED}⚠  Docker Compose is not configured in this project.${RESET}"
  echo ""
  echo "  ${DIM}No compose file found in the directory tree:${RESET}"
  echo "  ${DIM}  compose.yml / compose.yaml${RESET}"
  echo "  ${DIM}  docker-compose.yml / docker-compose.yaml${RESET}"
  echo ""
  read -n 1 -s -r -p "  Press any key to close..."
fi
