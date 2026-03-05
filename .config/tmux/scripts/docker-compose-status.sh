#!/bin/bash
# Docker Compose interactive status viewer for tmux popup
# Uses fzf for fuzzy filtering, log preview, and container actions.

# Iceberg color scheme
BLUE=$'\033[38;5;146m'
GREEN=$'\033[38;5;187m'
RED=$'\033[38;5;174m'
CYAN=$'\033[38;5;152m'
DIM=$'\033[38;5;103m'
ORANGE=$'\033[38;5;180m'
RESET=$'\033[0m'

# ---------------------------------------------------------------------------
# Sub-command: --list
#   Output colorized `docker compose ps` lines (one per container).
#   First line is the table header (used by fzf --header-lines).
# ---------------------------------------------------------------------------
if [ "$1" = "--list" ]; then
  docker compose ps --format "table {{.Name}}\t{{.Service}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null | awk '
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

# ---------------------------------------------------------------------------
# Sub-command: --preview <container_name>
#   Show recent logs for the given container.
# ---------------------------------------------------------------------------
if [ "$1" = "--preview" ]; then
  container="$2"
  echo "${CYAN}--- Logs: ${container} ---${RESET}"
  echo ""
  docker compose logs --tail=50 --no-log-prefix "$container" 2>/dev/null
  exit 0
fi

# ---------------------------------------------------------------------------
# Sub-command: --action <action> <container_name>
#   Perform an action on a container, then print updated status.
# ---------------------------------------------------------------------------
if [ "$1" = "--action" ]; then
  action="$2"
  container="$3"
  case "$action" in
    restart) docker compose restart "$container" 2>/dev/null ;;
    stop)    docker compose stop "$container" 2>/dev/null ;;
    start)   docker compose start "$container" 2>/dev/null ;;
  esac
  exit 0
fi

# ---------------------------------------------------------------------------
# Sub-command: --logs <container_name>
#   Follow logs in the current terminal (blocking).
# ---------------------------------------------------------------------------
if [ "$1" = "--logs" ]; then
  container="$2"
  docker compose logs -f --tail=100 --no-log-prefix "$container" 2>/dev/null
  exit 0
fi

# ---------------------------------------------------------------------------
# Sub-command: --exec <container_name>
#   Exec into a container with sh (falls back from bash).
# ---------------------------------------------------------------------------
if [ "$1" = "--exec" ]; then
  container="$2"
  docker compose exec "$container" bash 2>/dev/null || docker compose exec "$container" sh 2>/dev/null
  exit 0
fi

# ---------------------------------------------------------------------------
# Main: find compose file directory and launch fzf
# ---------------------------------------------------------------------------

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
    if [ "$dir" = "$home" ] || [ "$dir" = "/" ]; then
      return 1
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

compose_dir=$(find_compose_dir "$(pwd)")

if [ -z "$compose_dir" ]; then
  clear
  echo ""
  echo "  ${RED}Warning: Docker Compose is not configured in this project.${RESET}"
  echo ""
  echo "  ${DIM}No compose file found in the directory tree:${RESET}"
  echo "  ${DIM}  compose.yml / compose.yaml${RESET}"
  echo "  ${DIM}  docker-compose.yml / docker-compose.yaml${RESET}"
  echo ""
  read -n 1 -s -r -p "  Press any key to close..."
  exit 0
fi

cd "$compose_dir" || exit 1

SCRIPT="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
project_name=$(basename "$compose_dir")

header="${CYAN}Docker Compose${RESET}  ${DIM}(${project_name})${RESET}
${DIM}enter${RESET}:logs  ${DIM}ctrl-r${RESET}:restart  ${DIM}ctrl-s${RESET}:stop  ${DIM}ctrl-u${RESET}:start  ${DIM}ctrl-e${RESET}:exec  ${DIM}ctrl-space${RESET}:reload"

"$SCRIPT" --list | fzf \
  --ansi \
  --header-lines=1 \
  --header "$header" \
  --preview "\"$SCRIPT\" --preview {1}" \
  --preview-window "down:40%:wrap" \
  --bind "ctrl-space:reload(\"$SCRIPT\" --list | tail -n +2)" \
  --bind "ctrl-r:execute-silent(\"$SCRIPT\" --action restart {1})+reload(\"$SCRIPT\" --list | tail -n +2)" \
  --bind "ctrl-s:execute-silent(\"$SCRIPT\" --action stop {1})+reload(\"$SCRIPT\" --list | tail -n +2)" \
  --bind "ctrl-u:execute-silent(\"$SCRIPT\" --action start {1})+reload(\"$SCRIPT\" --list | tail -n +2)" \
  --bind "enter:execute(\"$SCRIPT\" --logs {1})" \
  --bind "ctrl-e:execute(\"$SCRIPT\" --exec {1})"
