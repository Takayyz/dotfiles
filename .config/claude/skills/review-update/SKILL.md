---
name: review-update
description: Update the status of an existing review note in Obsidian vault with dashboard synchronization.
allowedTools:
  - Read
---

# Review Update Skill

Interactively update the status of a review note and sync the Reviews dashboard.

## When to Use

- User says "update review", "review status update", "change review status", etc.
- Invoked as `/review-update`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Collect Review Notes

Glob all `.md` files in `$VAULT_DIR/reviews/`. Exclude `Reviews.md` (dashboard).

Parse frontmatter from each file to extract: `project`, `pr_url`, `priority`, `status`, `blocked_by`, `created`, `due`

### Step 3: Select Review Note

**If an index number is provided as an argument** (e.g., `/review-update 1`), use the same ordering as `/review-list` (priority desc, then created date asc) to resolve the index. Skip directly to Step 4 with the matched item.

**Otherwise**, present **non-done** review notes (status: `open` or `in-progress`) as a numbered list:

```
Select review to update:
  1. 2026-03-11-fix-auth [open] | high | project-a
  2. 2026-03-12-add-api [in-progress] | medium | project-b
Enter number (or "all" to include done):
```

- Default: show only `open` and `in-progress` notes
- If user enters "all", re-display including `done` notes
- If no updatable notes exist, display "No review notes found." and stop

**Index ordering rule**: Items are always ordered by priority desc (high > medium > low), then by created date asc within same priority. This matches the `/review-list` output so indices are interchangeable.

### Step 4: Select New Status

Present status options as a numbered list (exclude the current status):

```
Current status: open
Select new status:
  1. in-progress
  2. done
Enter number:
```

Valid statuses: `open`, `in-progress`, `done`

### Step 5: Ask for Comment

Ask if the user wants to add a comment to the review note:

```
Add a comment to this review? (enter text or skip):
```

- If provided, append the text as a list item under `## コメント` section
- If skipped, no changes to the comment section

### Step 6: Update Review Note

Update the frontmatter `status` field in the selected review note file.

- Change only the `status:` line value
- Do NOT modify any other frontmatter fields
- If a comment was provided in Step 5, append `- {comment}` under `## コメント`

### Step 7: Update Reviews Dashboard

Update `$VAULT_DIR/reviews/Reviews.md`:

1. **Remove** the entry from its current status section
2. **Add** the entry to the new status section, after the `<!-- ClaudeCodeが自動更新 -->` comment line
3. Preserve the entry format: `- [YYYY-MM-DD-slug](YYYY-MM-DD-slug.md) | **{priority}** | due: {due} | {project}`
   - Omit `due: ` part if no due date is set

### Step 8: Confirm

Display a summary of the changes:

```
Updated: 2026-03-11-fix-auth
  Status: open -> in-progress
  Comment: added (if applicable)
  Dashboard: synced
```

## Rules

- Do NOT allow changing to the same status the note already has.
- Do NOT modify any frontmatter fields other than `status`.
- If the entry is not found in `Reviews.md`, add it to the appropriate section instead of failing.
- When removing an entry from a section, ensure no extra blank lines are left behind.
