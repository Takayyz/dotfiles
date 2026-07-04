---
name: review-list
description: List and filter review notes from Obsidian vault by status, priority, and project. Shows merge readiness.
model: sonnet
allowedTools:
  - Read
---

# Review List Skill

Search and display review notes with filtering and merge-readiness analysis.

## When to Use

- User says "list reviews", "open reviews", "review status", etc.
- Invoked as `/review-list`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Collect Review Notes

Glob all `.md` files in `$VAULT_DIR/reviews/`. Exclude `Reviews.md` (dashboard).

### Step 3: Parse Frontmatter

Extract from each file:
- `project`, `pr_url`, `priority`, `status`, `blocked_by`, `created`, `due`

### Step 4: Apply Filters

Filter based on arguments:

| Argument | Behavior |
|----------|----------|
| (none) | Show `status: open` and `status: in-progress` |
| `--all` | Show all including `status: done` |
| `--project=ID` | Filter by project |
| `--priority=LEVEL` | Filter by priority |

### Step 5: Display as Table

Sort by priority (high then medium then low), then by created date within same priority. Assign a **global sequential index** (starting from 1).

Table columns: #, Priority, Note, Project, PR, Due, Blocked By, Mergeable

- Each item gets a unique index number, continuous across the list
- Ordering: priority desc (high > medium > low), then created date asc within same priority
- HIGH priority items should be displayed in bold
- Note links formatted as `[note-name](reviews/note-name.md)` (relative path)
- PR links formatted as `[PR#number](url)` (extract number from URL path)
- These indices can be used directly with `/review-update` (e.g., `/review-update 1`)

**Merge readiness logic:**
1. `blocked_by` is empty: "ready"
2. All `blocked_by` targets have `status: done`: "ready"
3. Otherwise: "blocked"

### Step 6: Summary

Print a concise summary line:

    Summary: open 3 / in-progress 1 / mergeable 2 / HIGH priority 1

## Rules

- Skip files with invalid frontmatter (missing required fields) and print a warning.
- If no review notes found, display "No review notes found."
- Format PR links as `[PR#number](url)` for readability.
