---
name: schedule
description: Fetch and display Google Calendar schedule via the gws CLI, falling back to the Google Calendar MCP connector when gws is unavailable.
model: sonnet
allowedTools:
  - Bash
  - ToolSearch
  - mcp__claude_ai_Google_Calendar__list_events
  - mcp__claude_ai_Google_Calendar__list_calendars
---

# Schedule Skill

Fetch and display upcoming Google Calendar events.

There are two ways to reach the calendar, and the helper script decides which
one applies:

1. **`gws` CLI** — preferred. The script fetches the events itself.
2. **Google Calendar MCP connector** — fallback, used when `gws` is missing or
   not authenticated. A shell script cannot call MCP tools, so in this case the
   script only resolves the date range and **you** perform the fetch.

## When to Use

- User says "schedule", "予定", "what's on my calendar", "today's meetings", etc.
- Invoked as `/schedule`

## Workflow

### Step 1: Parse Arguments

| Argument | Behavior |
|----------|----------|
| (none) | Today's events |
| `--tomorrow` | Tomorrow's events |
| `--week` | This week's events (Monday–Sunday) |
| `--days=N` | Next N days' events |
| `--all` | Show all calendars (combinable with above) |

### Step 2: Run the Helper Script

```bash
bash ~/.claude/skills/schedule/fetch-schedule.sh [args]
```

It always prints one JSON object and exits 0. Read the `source` key to decide
what to do next:

| `source` | Meaning | Next step |
|----------|---------|-----------|
| `"gws"` | Events are in the payload | Skip to Step 4 |
| `"mcp"` | Only the resolved range is in the payload | Do Step 3 |

Never treat `source: "mcp"` as an error — it is a normal branch. A non-zero
exit *is* an error: report it and stop.

### Step 3: MCP Fallback Fetch

Only when `source` is `"mcp"`. The payload looks like:

```json
{
  "source": "mcp",
  "reason": "gws CLI not found in PATH",
  "rangeDescription": "today",
  "startTime": "2026-09-10T00:00:00+09:00",
  "endTime": "2026-09-11T00:00:00+09:00",
  "timeZone": "Asia/Tokyo",
  "allCalendars": false
}
```

Call `list_events` with `startTime`, `endTime` and `timeZone` copied verbatim
from the payload, plus `orderBy: "startTime"`. Do not recompute the range —
using the script's values is what keeps both paths returning the same window.
Omit `timeZone` if the payload's value is an empty string.

If `allCalendars` is `true`, first call `list_calendars`, then call
`list_events` once per returned `calendarId`. Those calls are independent, so
issue them in a single message to run them concurrently.

**Resolving the tool names.** The connector is normally exposed as
`mcp__claude_ai_Google_Calendar__list_events` /
`mcp__claude_ai_Google_Calendar__list_calendars`, but the prefix depends on how
the connector is registered, and the tools are often deferred (name visible,
schema not loaded). In either case, load them first with a single call:

```
ToolSearch query: "select:mcp__claude_ai_Google_Calendar__list_events,mcp__claude_ai_Google_Calendar__list_calendars"
```

If that finds nothing, search by keyword instead: `ToolSearch query: "google calendar list events"`.
If no Google Calendar MCP tool exists at all, stop and tell the user that
neither `gws` nor the Calendar connector is available, quoting the payload's
`reason`.

### Step 4: Normalize Events

The two sources return different event shapes. Normalize to
`{start, end, summary, location, allDay, calendar}` before formatting:

| Field | `source: "gws"` | `source: "mcp"` |
|-------|-----------------|-----------------|
| all-day? | `start` has no `T` (e.g. `"2026-03-13"`) | `start.date` exists |
| start | `start` (string) | `start.dateTime` or `start.date` |
| end | `end` (string) | `end.dateTime` or `end.date` |
| summary | `summary` | `summary` |
| location | `location` (may be `""`) | `location` (key may be absent) |
| calendar | `calendar` | the `calendarId` you queried |

### Step 5: Format Output

**Group by date, sort within each date:**
1. All-day events first
2. Timed events in chronological order

**Display format:**

```
### 2026-03-13 (Thu)
  [終日] オフィス
  10:00-11:00 チーム定例
  13:00-14:00 1on1 with XXX

### 2026-03-14 (Fri)
  09:00-10:00 朝会
  14:00-15:00 レビュー会
```

- Timed events: show `HH:MM-HH:MM` (extract from ISO string, local time)
- All-day events: show `[終日]` prefix
- If `location` is present and non-empty, append ` @ <location>` after the summary
- Day-of-week abbreviation in parentheses (Mon-Sun)
- When `--all` is used, prepend `[calendar_name]` to each event summary

### Step 6: Summary

Print a concise summary line, using `rangeDescription` from the payload:

```
Summary: 6 events (today)
```

When the MCP fallback was used, add one short line noting it and why, so the
user knows `gws` needs attention:

```
(gws CLI not found in PATH — fetched via the Google Calendar MCP connector)
```

## Rules

- Read-only. Never create, modify, or delete events. Only `list_events` and
  `list_calendars` from the connector are permitted.
- If no events found, display "No events found for the specified range."
- Preserve event summaries exactly as returned by the API.
- Never recompute the date range yourself — always use the script's
  `startTime`/`endTime`, so the gws and MCP paths stay identical.
