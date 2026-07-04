---
name: handover
description: Carry over incomplete TODOs and in-progress reviews from the previous day's daily note to today.
model: haiku
allowedTools:
  - Read
  - Glob
  - Grep
---

# Handover Skill

Automate daily handover by carrying over incomplete TODOs and active reviews from the previous day.

## When to Use

- User says "handover", "carry over", "引き継ぎ", "start the day", etc.
- Invoked as `/handover`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Resolve Dates

```bash
TODAY=$(date +%Y-%m-%d)
```

Find the most recent daily note **before today**. Glob files in `$VAULT_DIR/daily/` matching `????-??-??.md`, sort descending, and pick the first one whose date is strictly before `$TODAY`. This is the **source** note.

**Target** is today's daily note: `$VAULT_DIR/daily/$TODAY.md`

If the target file does not exist:
1. Read `$VAULT_DIR/_templates/daily-template.md`
2. Replace `{{date}}` with today's date
3. Write the result to the target file

### Step 3: Read Source Daily Note

Read the source file and extract:

#### 3a: Incomplete TODOs

Extract lines between `## TODO` and the next `##` heading. Collect only lines matching `- [ ] ...` (incomplete items). Ignore `- [x] ...` (completed items).

#### 3b: Review Links

Extract lines between `## Review` and the next `##` heading (or end of file). Collect all review file links. Links are formatted as:
```
[note-name](../reviews/note-name.md)
```

### Step 4: Filter Reviews by Status

For each review link collected in Step 3b:
1. Resolve the file path (e.g., `$VAULT_DIR/reviews/note-name.md`)
2. Read the frontmatter `status` field
3. Keep only reviews where `status` is **not** `done` (i.e., keep `open`, `in-progress`)

### Step 5: Check Target for Duplicates

Read the target daily note. For each TODO and review link about to be carried over, check if it already exists in the target file. Skip duplicates.

### Step 6: Mark Source TODOs as Handed Over

For each incomplete TODO that will be carried over, update the **source** daily note:

- Change `- [ ]` to `- [x]`
- Append ` (→M/D)` (target date in short format, e.g., `(→3/25)`) to the end of the line

Example: `- [ ] [dev]some task` becomes `- [x] [dev]some task (→3/25)`

### Step 7: Write to Target

Use the **Edit tool** to insert items into the target daily note:

- Append incomplete TODOs to the `## TODO` section (before the next `##` heading)
- Append active review links to the `## Review` section (before the next `##` heading or end of file)

**Never overwrite existing content. Append only.**

### Step 8: Summary

Display a summary of what was carried over:

```
Handover from YYYY-MM-DD:

TODO (N items):
- [ ] task A
- [ ] task B

Review (N items):
- note-name-1 (status)
- note-name-2 (status)

Skipped:
- review-xyz (done)
```

If nothing to carry over, display:
```
Handover from YYYY-MM-DD: nothing to carry over.
```

## Rules

- Never overwrite existing content in the target daily note. Append only.
- Source daily note is modified **only** to mark handed-over TODOs as complete (Step 6). No other changes.
- Skip duplicate items that already exist in the target.
- If no source daily note is found, report: "No previous daily note found."
- If the source has no TODO section or Review section, skip that part silently.
- Preserve the original text of each TODO item exactly as written.
- Preserve the original link format of each review entry exactly as written.
