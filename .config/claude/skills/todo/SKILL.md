---
name: todo
description: Append a TODO item to today's Obsidian daily note (daily/ folder).
---

# TODO Skill

Add TODO items to today's daily note.

## When to Use

- User says "todo", "add task", "remind me to", etc.
- Invoked as `/todo content here`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
```

### Step 2: Resolve Today's Daily Note

```bash
TODAY=$(date +%Y-%m-%d)
DAILY_FILE="$VAULT_DIR/daily/$TODAY.md"
```

If the file does not exist:
1. Read `$VAULT_DIR/_templates/daily-template.md`
2. Replace `{{date}}` with today's date
3. Write the result to `$DAILY_FILE`

### Step 3: Get TODO Content

- Use arguments if provided with the skill invocation
- Otherwise ask: "What's the TODO?"
- If multiple lines are given, treat each as a separate TODO item

### Step 4: Append to TODO Section

Append to the end of the `## TODO` section (just before the next `##` heading).

Each item uses Obsidian checkbox format:

    - [ ] content

**Use the Edit tool to append. Never overwrite the entire file.**

### Step 5: Confirm

Display the full current TODO list from the file.

## Rules

- Never overwrite existing content. Append only.
- If `## TODO` section is missing, report an error (template may be corrupted).
- Always use Obsidian checkbox format (enables toggling in Obsidian UI).
