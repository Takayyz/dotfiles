---
name: 1on1
description: Create a new 1on1 session note in Obsidian vault with person selection.
---

# 1on1 Skill

Create a 1on1 session note for today.

## When to Use

- User says "1on1", "1on1ログ", etc.
- Invoked as `/1on1`

## Workflow

### Step 1: Locate Vault

```bash
VAULT_DIR="$HOME/repo/github.com/Takayyz/obsidian-vaults/vaults"
ONEONONE_DIR="$VAULT_DIR/1on1"
```

### Step 2: Identify Person

List subdirectories under `$ONEONONE_DIR` (excluding files) and present them as a numbered list.

```
Select person:
  1. person1
  2. person2
Enter number (or new name to add):
```

If the user enters a name that doesn't exist yet:
1. Create the directory
2. Create a `_next.md` file for that person
3. Create a `{person}.md` index page with frontmatter (`person`, `type: 1on1-member`) and sections for Sessions and Next Topics
4. Add a link to the new person page in `$ONEONONE_DIR/1on1.md` Members table

### Step 3: Check for Next Topics

Read `$ONEONONE_DIR/{person}/_next.md` if it exists. If there are topics listed (non-empty lines under `# Next Topics`), show them:

```
Pending topics for {person}:
- topic 1
- topic 2
Include these in today's session? (Y/n)
```

If yes, pre-fill the Topics section of the new note.

### Step 4: Create Session Note

File path: `$ONEONONE_DIR/{person}/YYYY-MM-DD.md`

Use `$VAULT_DIR/_templates/1on1-session-template.md` as base:
- Replace `{{date}}` with today's date
- Set `person` in frontmatter
- If topics were included from Step 3, add them under `## Topics`

### Step 5: Clear Used Topics

If topics from `_next.md` were included, reset `_next.md` to empty state:

```markdown
---
person: {person}
---

# Next Topics

<!-- 次回の1on1で話したいトピックをここに追加 -->

-
```

### Step 6: Update Person Index

Append a link to the new session in `$ONEONONE_DIR/{person}/{person}.md` under `## Sessions`:

```markdown
- [YYYY-MM-DD](YYYY-MM-DD.md)
```

### Step 7: Confirm

Display the created note path and contents.

## Rules

- If a session note for today already exists for the person, do NOT overwrite. Ask the user.
- Person directory names should be lowercase alphanumeric.
- Use local system time (JST) for date resolution.
