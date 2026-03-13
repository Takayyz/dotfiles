---
name: todo-update
description: Interactively update TODO item status in Obsidian daily notes.
allowedTools:
  - Read
  - Glob
  - Edit
---

# TODO Update Skill

Interactively toggle TODO item completion status in daily notes.

## When to Use

- User says "update todo", "complete todo", "todo done", "reopen todo", etc.
- Invoked as `/todo-update`

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

Calculate the date range and glob matching files in `$VAULT_DIR/daily/`.

### Step 3: Collect TODO Items

For each daily note in the date range (newest first):
1. Read the file
2. Extract lines between `## TODO` and the next `##` heading
3. Parse each line as either:
   - `- [ ] content` (incomplete)
   - `- [x] content` (complete)
4. Record the date (from filename), line number, and completion status for each item

Skip files that don't exist or have no `## TODO` section.

### Step 4: Present TODO Items

**If index numbers are provided as arguments** (e.g., `/todo-update 1,3`), use the same ordering as `/todo-list` (newest date first, then file order within each date) to resolve the indices. Skip directly to Step 5 with the matched items.

**Otherwise**, collect and display items interactively.

By default, show only **incomplete** items as a numbered list:

```
Select TODO(s) to update:
  1. [ ] [2026-01-03] Buy groceries
  2. [ ] [2026-01-03] Write meeting notes
  3. [ ] [2026-01-02] Review PR #42
Enter number(s) (comma-separated, or "all" to include completed):
```

- Default: show only incomplete (`- [ ]`) items
- If user enters "all", re-display including completed (`- [x]`) items with their status shown
- If no updatable items exist, display "No TODO items found in the specified range." and stop

When showing all items, indicate current status:

```
Select TODO(s) to update:
  1. [ ] [2026-01-03] Buy groceries
  2. [ ] [2026-01-03] Write meeting notes
  3. [x] [2026-01-02] Send invoice
  4. [x] [2026-01-02] Fix login bug
Enter number(s) (comma-separated):
```

**Index ordering rule**: Items are always ordered by newest date first, then by file appearance order within each date. This matches the `/todo-list` output so indices are interchangeable.

### Step 5: Select Action

Present action options:

```
Action:
  1. Complete ([ ] -> [x])
  2. Reopen  ([x] -> [ ])
Enter number:
```

- If all selected items are incomplete, default to "Complete"
- If all selected items are complete, default to "Reopen"
- If mixed, always ask

### Step 6: Update Daily Note

For each selected item, edit the daily note file:

- **Complete**: Change `- [ ]` to `- [x]` on the target line
- **Reopen**: Change `- [x]` to `- [ ]` on the target line

Use the Edit tool. Only modify the checkbox portion of the line. Do NOT change any other content.

### Step 7: Carry Forward Incomplete Items (Optional)

If the updated item is from a **past date** (not today) and the action was **Reopen**, ask:

```
This item is from a past date. Carry forward to today's note? (y/n):
```

- If yes, append the item as `- [ ] content` to today's `## TODO` section
- If today's daily note doesn't exist, create it from the template (`$VAULT_DIR/_templates/daily-template.md`, replacing `{{date}}`)
- Do NOT remove the item from the original date's note

### Step 8: Confirm

Display a summary of the changes:

```
Updated:
  [2026-01-03] Buy groceries: [ ] -> [x]
  [2026-01-03] Write meeting notes: [ ] -> [x]
```

If items were carried forward:

```
Carried forward to 2026-01-03:
  - [ ] Review PR #42
```

## Rules

- Do NOT allow toggling to the same state (e.g., completing an already completed item).
- Only modify the checkbox marker (`- [ ]` / `- [x]`). Never change the content text.
- Use the Edit tool for all file modifications. Never overwrite the entire file.
- If `## TODO` section is missing in a daily note, skip it silently.
- Preserve the original text of each TODO item exactly as written.
