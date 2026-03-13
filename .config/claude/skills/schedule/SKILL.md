---
name: schedule
description: Fetch and display Google Calendar schedule using gws CLI.
allowedTools:
  - Bash
---

# Schedule Skill

Fetch and display upcoming Google Calendar events via the `gws` CLI.

## When to Use

- User says "schedule", "予定", "what's on my calendar", "today's meetings", etc.
- Invoked as `/schedule`

## Workflow

### Step 1: Parse Arguments

| Argument | Behavior |
|----------|----------|
| (none) | Today's events |
| `--tomorrow` | Tomorrow's events |
| `--week` | This week's events |
| `--days=N` | Next N days' events |
| `--all` | Show all calendars (combinable with above) |

### Step 2: Fetch Events

Run the helper script with the parsed arguments:

```bash
bash ~/.claude/skills/schedule/fetch-schedule.sh [args]
```

The script handles:
- Primary calendar detection (filters to own calendar by default)
- Date range selection
- Returns JSON with `count` and `events` array

### Step 3: Format Output

Parse the JSON response. Each event has: `calendar`, `start`, `end`, `summary`, `location`.

**Distinguish event types by `start` format:**
- All-day event: `"2026-03-13"` (date only, no `T`)
- Timed event: `"2026-03-13T10:00:00+09:00"` (ISO datetime with `T`)

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
- If `location` is non-empty, append ` @ <location>` after the summary
- Day-of-week abbreviation in parentheses (Mon-Sun)
- When `--all` is used, prepend `[calendar_name]` to each event summary

### Step 4: Summary

Print a concise summary line:

```
Summary: 6 events (<range_description>)
```

Where `<range_description>` is: `today`, `tomorrow`, `this week`, or `N days`.

## Rules

- Read-only. Never create, modify, or delete events.
- If no events found, display "No events found for the specified range."
- Preserve event summaries exactly as returned by the API.
