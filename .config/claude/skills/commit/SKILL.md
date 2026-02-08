---
name: commit
description: Creates git commits with well-formatted messages. Checks for .gitmessage template in project root and follows its format, otherwise uses conventional commits. Analyzes existing commit history to match tone and style.
---

# Git Commit Skill

This skill creates git commits with properly formatted commit messages that match the project's conventions and style.

## When to Use

- When the user asks to commit changes
- When the user says "commit", "コミットして", "変更をコミット", etc.
- After completing a task when the user requests a commit

## Workflow

### Step 1: Check for .gitmessage Template

First, check if the project has a `.gitmessage` file:

```bash
cat .gitmessage 2>/dev/null || echo "NO_GITMESSAGE_FOUND"
```

If `.gitmessage` exists:
- Parse its format, prefixes, and structure
- Follow the template exactly when composing the commit message

If `.gitmessage` does not exist:
- Use Conventional Commits format (see below)

### Step 2: Analyze Current Changes

Run these commands to understand what will be committed:

```bash
# Check untracked and modified files (never use -uall flag)
git status

# View staged and unstaged changes
git diff
git diff --cached
```

### Step 3: Analyze Existing Commit Style

Check recent commits to match tone and style:

```bash
git log --oneline -10
```

Pay attention to:
- Prefix usage (feat, fix, refactor, update, etc.)
- Case style (lowercase vs sentence case)
- Message length and detail level
- Language (English vs other)

### Step 4: Compose Commit Message

#### If .gitmessage Template Exists

Follow the template structure exactly. Common template elements include:
- Type prefix (feat, fix, docs, etc.)
- Scope in parentheses (optional)
- Subject line
- Body (optional)
- Footer with issue references (optional)

#### If No .gitmessage (Conventional Commits)

Use lowercase conventional commits format:

| Prefix | Use Case |
|--------|----------|
| `feat:` | New feature or functionality |
| `fix:` | Bug fix |
| `refactor:` | Code restructuring without behavior change |
| `update:` | Enhancements to existing features |
| `docs:` | Documentation changes only |
| `style:` | Formatting, whitespace (no code change) |
| `test:` | Adding or updating tests |
| `chore:` | Build, config, tooling changes |
| `perf:` | Performance improvements |

**Message Guidelines:**
- Subject line: max 50 characters, imperative mood, no period
- Use lowercase for prefix
- Be concise but descriptive
- Focus on "why" not just "what"
- **Body must use markdown list format** (`-` prefix) when describing changes

### Step 5: Stage and Commit

**IMPORTANT: Stage specific files, not everything**

```bash
# Stage specific files
git add path/to/file1 path/to/file2

# Create commit with HEREDOC for proper formatting
git commit -m "$(cat <<'EOF'
feat: add user authentication flow

- implement JWT-based authentication with refresh token support
- add login/logout API endpoints
EOF
)"
```

### Step 6: Verify Success

```bash
git status
git log -1
```

## Safety Rules

- **NEVER** push automatically - only commit locally
- **NEVER** use `git add -A` or `git add .` - stage specific files
- **NEVER** use `--amend` unless explicitly requested
- **NEVER** use `--no-verify` unless explicitly requested
- **NEVER** commit files that may contain secrets (.env, credentials, etc.)
- If pre-commit hook fails, fix the issue and create a NEW commit

## Example Interactions

**User**: コミットして
**Action**:
1. Check for `.gitmessage`
2. Run `git status` and `git diff`
3. Run `git log --oneline -10` to check style
4. Compose message matching project conventions
5. Stage changed files explicitly
6. Create commit
7. Verify with `git status`

**User**: Commit the changes we just made
**Action**: Same workflow as above

**User**: Fix the linting errors and commit
**Action**: Fix errors first, then follow commit workflow

## Multi-file Commit Guidelines

When committing multiple related changes:
- Group logically related changes in a single commit
- Use a clear subject that summarizes all changes
- List specific changes in the body using markdown list format (`-` prefix)

When changes are unrelated:
- Ask the user if they want separate commits
- Or create one commit with a general description

## Handling Ambiguity

If unclear about:
- **What to commit**: Ask user to specify files
- **Commit message content**: Propose a message and ask for confirmation
- **Multiple unrelated changes**: Ask if user wants separate commits
