---
name: memo
description: Append a timestamped memo to today's Obsidian daily note (daily/ folder).
---

# Memo Skill

Quickly append a memo entry to today's daily note.

## When to Use

- User says "memo", "note this", "jot down", etc.
- Invoked as `/memo <content>`

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

### Step 3: Get Memo Content

- Use arguments if provided with the skill invocation
- Otherwise ask: "What would you like to memo?"

### Step 4: Append to Memo Section

Get the current time:

```bash
TIME=$(date +%H:%M)
```

Append the following line to the end of the `## Memo` section (just before the next `##` heading):

```
- HH:MM content
```

**Use the Edit tool to append. Never overwrite the entire file.**

### Step 5: Confirm

Display the appended line:

```
Appended: - 14:30 content here
```

## Rules

- Never overwrite existing content. Append only.
- If `## Memo` section is missing, report an error (template may be corrupted).
- Use local system time (JST) for timestamps.
