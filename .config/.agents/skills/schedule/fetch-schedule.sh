#!/bin/bash
set -euo pipefail

# Resolve a calendar date range and, when the `gws` CLI is available, fetch the
# events for it. Always outputs a single JSON object on stdout with a `source`
# key telling the caller which path was taken:
#
#   {"source": "gws", "count": N, "events": [...], ...}
#     -> events were fetched; format them directly.
#
#   {"source": "mcp", "startTime": "...", "endTime": "...", ...}
#     -> no events here. The caller must fetch them via the Google Calendar
#        MCP connector using the resolved range. A shell script cannot call
#        MCP tools, so the fallback is completed by the model, not by us.
#
# Exit status is 0 for both paths: falling back is a normal outcome, not a
# failure. A non-zero exit means the arguments or the environment are broken.

usage() {
  cat <<'USAGE'
Usage: fetch-schedule.sh [--today|--tomorrow|--week|--days N] [--all]
  --today      Today's events (default)
  --tomorrow   Tomorrow's events
  --week       This week's events (Monday through Sunday)
  --days N     Next N days' events, starting today
  --all        Include every calendar (default: primary only)
USAGE
}

DATE_MODE="today"
DAYS_N=""
ALL_CALENDARS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --today)    DATE_MODE="today"; shift ;;
    --tomorrow) DATE_MODE="tomorrow"; shift ;;
    --week)     DATE_MODE="week"; shift ;;
    --days)     DATE_MODE="days"; DAYS_N="${2:-}"; shift 2 ;;
    --days=*)   DATE_MODE="days"; DAYS_N="${1#*=}"; shift ;;
    --all)      ALL_CALENDARS=true; shift ;;
    -h|--help)  usage; exit 0 ;;
    *)          echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ "$DATE_MODE" == "days" ]]; then
  if ! [[ "$DAYS_N" =~ ^[0-9]+$ ]] || [[ "$DAYS_N" -lt 1 ]]; then
    echo "--days requires a positive integer, got: '${DAYS_N}'" >&2
    exit 1
  fi
fi

# --- date helpers -----------------------------------------------------------
# BSD (macOS) and GNU date take incompatible flags; detect once and branch.
if date -j -f "%Y-%m-%d" "2000-01-01" "+%Y" >/dev/null 2>&1; then
  DATE_IMPL="bsd"
else
  DATE_IMPL="gnu"
fi

# shift_date <YYYY-MM-DD> <signed days, e.g. +3 or -2> -> YYYY-MM-DD
shift_date() {
  if [[ "$DATE_IMPL" == "bsd" ]]; then
    date -j -v"${2}d" -f "%Y-%m-%d" "$1" "+%Y-%m-%d"
  else
    date -d "$1 ${2} days" "+%Y-%m-%d"
  fi
}

# utc_offset <YYYY-MM-DD> -> +09:00
# Computed per-date rather than once, so a range straddling a DST boundary
# still produces correct timestamps.
utc_offset() {
  local z
  if [[ "$DATE_IMPL" == "bsd" ]]; then
    z=$(date -j -f "%Y-%m-%d %H:%M:%S" "$1 00:00:00" "+%z")
  else
    z=$(date -d "$1 00:00:00" "+%z")
  fi
  printf '%s:%s' "${z:0:3}" "${z:3:2}"
}

# Midnight at the start of the given date, as an ISO 8601 timestamp.
iso_midnight() {
  printf '%sT00:00:00%s' "$1" "$(utc_offset "$1")"
}

# Best-effort IANA zone name. Empty is fine: the offsets above already pin the
# range down unambiguously, so this is only a convenience for the API call.
tz_name() {
  if [[ -n "${TZ:-}" ]]; then
    printf '%s' "$TZ"
    return
  fi
  local link
  link=$(readlink /etc/localtime 2>/dev/null || true)
  case "$link" in
    */zoneinfo/*) printf '%s' "${link#*/zoneinfo/}" ;;
    *)            printf '' ;;
  esac
}

# --- resolve the range ------------------------------------------------------
TODAY=$(date "+%Y-%m-%d")

case "$DATE_MODE" in
  today)
    START_DATE="$TODAY"
    END_DATE=$(shift_date "$TODAY" "+1")
    RANGE_DESC="today"
    ;;
  tomorrow)
    START_DATE=$(shift_date "$TODAY" "+1")
    END_DATE=$(shift_date "$TODAY" "+2")
    RANGE_DESC="tomorrow"
    ;;
  week)
    # %u is 1 (Monday) through 7 (Sunday) on both date implementations.
    START_DATE=$(shift_date "$TODAY" "-$(( $(date "+%u") - 1 ))")
    END_DATE=$(shift_date "$START_DATE" "+7")
    RANGE_DESC="this week"
    ;;
  days)
    START_DATE="$TODAY"
    END_DATE=$(shift_date "$TODAY" "+${DAYS_N}")
    RANGE_DESC="${DAYS_N} days"
    ;;
esac

START_TIME=$(iso_midnight "$START_DATE")
END_TIME=$(iso_midnight "$END_DATE")
TZ_NAME=$(tz_name)

# --- emit the MCP fallback directive ----------------------------------------
emit_mcp_fallback() {
  local reason="$1" escaped_reason
  if command -v jq >/dev/null 2>&1; then
    escaped_reason=$(printf '%s' "$reason" | jq -Rs .)
  else
    escaped_reason='"gws CLI unavailable"'
  fi
  cat <<JSON
{
  "source": "mcp",
  "reason": ${escaped_reason},
  "rangeDescription": "${RANGE_DESC}",
  "startTime": "${START_TIME}",
  "endTime": "${END_TIME}",
  "timeZone": "${TZ_NAME}",
  "allCalendars": ${ALL_CALENDARS}
}
JSON
}

if ! command -v gws >/dev/null 2>&1; then
  emit_mcp_fallback "gws CLI not found in PATH"
  exit 0
fi

# --- gws path ---------------------------------------------------------------
if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required for the gws path but was not found in PATH" >&2
  exit 1
fi

CALENDAR_FLAG=""
if [[ "$ALL_CALENDARS" == false ]]; then
  if ! PRIMARY_ID=$(gws calendar calendarList list --format json 2>/dev/null \
      | jq -r '.items[] | select(.primary == true) | .id') || [[ -z "$PRIMARY_ID" ]]; then
    emit_mcp_fallback "gws could not determine the primary calendar ID (likely not authenticated)"
    exit 0
  fi
  CALENDAR_FLAG="--calendar ${PRIMARY_ID}"
fi

DATE_FLAG="--${DATE_MODE}"
[[ "$DATE_MODE" == "days" ]] && DATE_FLAG="--days ${DAYS_N}"

# shellcheck disable=SC2086
if ! GWS_OUT=$(gws calendar +agenda ${DATE_FLAG} --format json ${CALENDAR_FLAG} 2>&1); then
  emit_mcp_fallback "gws agenda failed: ${GWS_OUT}"
  exit 0
fi

printf '%s' "$GWS_OUT" | jq \
  --arg source "gws" \
  --arg rangeDescription "$RANGE_DESC" \
  --arg startTime "$START_TIME" \
  --arg endTime "$END_TIME" \
  '. + {source: $source, rangeDescription: $rangeDescription, startTime: $startTime, endTime: $endTime}'
