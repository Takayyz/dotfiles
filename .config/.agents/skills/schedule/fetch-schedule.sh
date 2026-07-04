#!/bin/bash
set -euo pipefail

# Fetch Google Calendar events using gws CLI.
# Outputs filtered JSON to stdout.
#
# Usage: fetch-schedule.sh [--today|--tomorrow|--week|--days N] [--all]
#   --today      Today's events (default)
#   --tomorrow   Tomorrow's events
#   --week       This week's events
#   --days N     Next N days' events
#   --all        Show all calendars (default: primary only)

DATE_FLAG="--today"
ALL_CALENDARS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --today)    DATE_FLAG="--today"; shift ;;
    --tomorrow) DATE_FLAG="--tomorrow"; shift ;;
    --week)     DATE_FLAG="--week"; shift ;;
    --days)     DATE_FLAG="--days $2"; shift 2 ;;
    --days=*)   DATE_FLAG="--days ${1#*=}"; shift ;;
    --all)      ALL_CALENDARS=true; shift ;;
    *)          echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

CALENDAR_FLAG=""
if [[ "$ALL_CALENDARS" == false ]]; then
  PRIMARY_ID=$(gws calendar calendarList list --format json \
    | jq -r '.items[] | select(.primary == true) | .id')
  if [[ -z "$PRIMARY_ID" ]]; then
    echo '{"error": "Could not determine primary calendar ID"}' >&2
    exit 1
  fi
  CALENDAR_FLAG="--calendar ${PRIMARY_ID}"
fi

# shellcheck disable=SC2086
gws calendar +agenda ${DATE_FLAG} --format json ${CALENDAR_FLAG}
