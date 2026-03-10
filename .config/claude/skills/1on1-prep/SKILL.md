---
name: 1on1-prep
description: Prepare topics for the next 1on1 session based on past logs and pending items.
---

# 1on1 Prep Skill

Organize and suggest topics for an upcoming 1on1.

## When to Use

- User says "1on1準備", "next 1on1", "1on1 prep", etc.
- Invoked as `/1on1-prep`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
ONEONONE_DIR="$VAULT_DIR/1on1"
```

### Step 2: Select Person

List subdirectories under `$ONEONONE_DIR` and present as a numbered list.

### Step 3: Gather Context

Read the following in parallel:

1. `$ONEONONE_DIR/{person}/_next.md` - pending topics
2. Latest 2-3 session notes from `$ONEONONE_DIR/{person}/` - for context and follow-ups

### Step 4: Generate Prep Sheet

Analyze the data and present:

```markdown
## {person} 1on1 Prep

### Pending Topics (_next.md)
- topic1
- topic2

### Follow-ups from Previous Sessions
- 前回のAction Itemsの進捗確認: ...
- 継続的なテーマ: ...

### Suggested Topics
- 提案1（理由）
- 提案2（理由）
```

### Step 5: Update _next.md (Optional)

Ask the user:

```
Update _next.md with these topics? (y/N)
```

If yes, write the organized topics to `_next.md`.

## Rules

- Output in Japanese.
- Suggestions should be based on actual data from past sessions, not generic.
- Do not overwrite `_next.md` without user confirmation.
