---
name: todo-list
description: List and filter TODO items from Obsidian daily notes across multiple days.
allowedTools:
  - Read
  - Glob
---

# TODO List Skill

Collect and display TODO items from daily notes with filtering options.

## When to Use

- User says "todo list", "show todos", "open tasks", "what's left", etc.
- Invoked as `/todo-list`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Determine Date Range

Parse arguments to determine which daily notes to scan:

| Argument | Behavior |
|----------|----------|
| (none) | Last 7 days |
| `--today` | Today only |
| `--days=N` | Last N days |
| `--all` | Include completed (`- [x]`) items (combinable with above) |

Calculate the date range and glob matching files in `$VAULT_DIR/daily/`.

### Step 3: Collect TODO Items

For each daily note in the date range:
1. Read the file
2. Extract lines between `## TODO` and the next `##` heading
3. Parse each line as either:
   - `- [ ] content` (incomplete)
   - `- [x] content` (complete)
4. Record the date (from filename) and completion status for each item

Skip files that don't exist or have no `## TODO` section.

### Step 4: Apply Filters

- By default, show only incomplete items (`- [ ]`)
- With `--all`, show both incomplete and complete items

### Step 5: Display Results

Group items by date (newest first). Format:

```
### 2026-01-01
- [ ] task A
- [ ] task B

### 2025-12-31
- [x] task C
```

- Incomplete items shown as `- [ ]`
- Complete items shown as `- [x]` (only when `--all`)
- Dates with no matching items are omitted

### Step 6: Summary

Print a concise summary line:

```
Summary: incomplete 3 / complete 1 / total 4 (7 days)
```

## Rules

- Read-only. Never modify daily notes.
- Skip daily notes with missing or malformed `## TODO` section silently.
- If no TODO items found, display "No TODO items found in the specified range."
- Preserve the original text of each TODO item exactly as written.
