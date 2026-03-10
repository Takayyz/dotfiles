---
name: review-create
description: Create a new code review note in Obsidian vault with project selection, priority, and dependency tracking.
---

# Review Create Skill

Interactively create a review management note.

## When to Use

- User says "create review", "new review note", etc.
- Invoked as `/review-create`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Load Project List

Read `$VAULT_DIR/_config/projects.yml` and parse the project entries.

### Step 3: Gather Information

Ask the user for the following (skip items already provided as arguments):

1. **project** (required): Present projects.yml entries as a numbered list

       Select project:
         1. my-project - example project
       Enter number:

2. **PR URL** (required): GitHub PR URL

3. **slug** (required): Short identifier for the filename
   - Alphanumeric and hyphens only
   - e.g. `fix-auth-flow`, `add-user-api`

4. **priority** (optional): `high` / `medium` / `low`
   - Default: `medium`

5. **due** (optional): Deadline in YYYY-MM-DD format
   - Default: empty

6. **blocked_by** (optional): Dependent review notes
   - List existing open/in-progress notes from reviews/ as numbered options
   - Allow multiple selection (comma-separated)
   - Skip if none

### Step 4: Create Review Note

File path: `$VAULT_DIR/reviews/YYYY-MM-DD-{slug}.md`

Use `$VAULT_DIR/_templates/review-template.md` as base:
- Replace `{{date}}` with today's date
- Fill in all frontmatter fields
- If `blocked_by` is set, add Markdown links under the `## Dependencies` section
  - Format: `[note-name](note-name.md)` (relative path within reviews/)

Example frontmatter:

```yaml
---
type: review
project: my-project
pr_url: "https://github.com/org/repo/pull/42"
priority: high
status: open
blocked_by:
  - "2026-03-10-fix-auth"
created: "2026-03-11"
due: "2026-03-13"
---
```

### Step 5: Link from Daily Note

Append a Markdown link to the `## Review` section of today's daily note.

Format: `[YYYY-MM-DD-slug](../reviews/YYYY-MM-DD-slug.md)` (relative path from daily/)

If the daily note does not exist, create it from the template first.

### Step 6: Confirm

Display the created note contents.

## Rules

- slug must contain only alphanumeric characters and hyphens.
- If a file with the same name already exists, do NOT overwrite. Ask the user.
- Reject project IDs not found in projects.yml.
