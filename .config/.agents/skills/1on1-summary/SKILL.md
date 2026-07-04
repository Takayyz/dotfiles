---
name: 1on1-summary
description: Summarize recent 1on1 sessions for a specific person from Obsidian vault.
---

# 1on1 Summary Skill

Generate a summary of recent 1on1 sessions.

## When to Use

- User says "1on1まとめ", "1on1振り返り", "summarize 1on1", etc.
- Invoked as `/1on1-summary`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
ONEONONE_DIR="$VAULT_DIR/1on1"
```

### Step 2: Select Person

List subdirectories under `$ONEONONE_DIR` and present as a numbered list.

```
Select person:
  1. person1
  2. person2
Enter number:
```

### Step 3: Determine Range

Ask the user (skip if provided as argument):

```
How many recent sessions? (default: 3)
```

### Step 4: Read Session Notes

List all `YYYY-MM-DD.md` files in `$ONEONONE_DIR/{person}/`, sort by date descending, and read the latest N files.

### Step 5: Generate Summary

Analyze the session notes and produce a summary in Japanese with the following structure:

```markdown
## {person} 1on1 サマリー（直近{N}回）

### 期間
YYYY-MM-DD 〜 YYYY-MM-DD

### 主要トピック
- トピック1: 概要
- トピック2: 概要

### 経時変化・傾向
- 変化の観察

### 未解決・継続事項
- [ ] アイテム

### 次回に向けて
- 提案事項
```

### Step 6: Output

Display the summary directly to the user. Do NOT write the summary to a file unless the user asks.

## Rules

- Read ALL session notes in the specified range before generating the summary.
- Summary should be in Japanese.
- Focus on identifying patterns, changes over time, and actionable items.
- Do not fabricate information. Only summarize what's in the notes.
