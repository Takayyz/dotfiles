---
name: herdr
description: Control herdr workspaces, tabs, and panes — split terminals, run commands, wait for output, coordinate with other agents.
---

# herdr — agent skill

## Prerequisites

**Check environment first:**
```bash
echo $HERDR_ENV
```

If `HERDR_ENV` is not set to `1`, you are not running inside a herdr-managed pane. Do not attempt to use this skill. Say so and stop.

If `HERDR_ENV=1`, you are inside herdr and can control workspaces, tabs, panes, and coordinate with other agents.

## Concepts

**Workspaces** — Project contexts. One or more tabs per workspace. Default name from repo/folder.

**Tabs** — Subcontexts within a workspace. Multiple panes per tab.

**Panes** — Terminal splits. Each runs its own process (shell, agent, server, log stream).

**Agent Status** — Auto-detected. Values:
- `idle` — Ready
- `working` — Currently processing
- `blocked` — Waiting for input/dependencies
- `done` — Finished (unread)
- `unknown` — No agent detected

**IDs** — Compact, ephemeral. Re-read them after mutations:
- Workspace: `1`, `2`, `3`
- Tab: `1:1`, `1:2`, `2:1`
- Pane: `1-1`, `1-2`, `2-1`

**Important:** IDs compact when items close. Always fetch fresh IDs from `list` or `create` responses. Never assume an old ID still maps to the same pane.

## Discover Context

**See all panes and find yours:**
```bash
herdr pane list
```
Your focused pane is listed as focused. Others are neighbors.

**List workspaces:**
```bash
herdr workspace list
```

**List tabs in a workspace:**
```bash
herdr tab list --workspace 1
```

## Common Workflows

### Read Another Pane's Output

```bash
herdr pane read 1-1 --source recent --lines 50
```

Options:
- `--source visible` — Current viewport
- `--source recent` — Recent scrollback (wrapped as rendered)
- `--source recent-unwrapped` — Raw text with soft wraps joined

### Split a Pane and Run a Command

Split right, don't switch focus:
```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
```

Split down:
```bash
herdr pane split 1-2 --direction down --no-focus
```

### Wait for Output

Block until text appears (useful for servers, builds, tests):
```bash
herdr wait output 1-3 --match "ready on port 3000" --timeout 30000
```

With regex:
```bash
herdr wait output 1-3 --match "server.*ready" --regex --timeout 30000
```

Exit code `1` on timeout.

### Wait for Another Agent

```bash
herdr wait agent-status 1-1 --status done --timeout 60000
```

Use this to coordinate with sibling agents. `done` means the agent finished.

### Create a Tab for Logs or Utilities

```bash
herdr tab create --workspace 1 --label "logs"
NEW_TAB=$(herdr tab create --workspace 1 --label "test" | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["tab"]["tab_id"])')
herdr tab focus "$NEW_TAB"
```

### Create a New Workspace

```bash
herdr workspace create --cwd ~/project/new-context --label "api-refactor"
```

## Practical Recipes

### Run a Dev Server and Wait for Ready

```bash
NEW_PANE=$(herdr pane split 1-2 --direction right --no-focus | python3 -c 'import sys,json; print(json.load(sys.stdin)["result"]["pane"]["pane_id"])')
herdr pane run "$NEW_PANE" "npm run dev"
herdr wait output "$NEW_PANE" --match "ready" --timeout 30000
herdr pane read "$NEW_PANE" --source recent --lines 20
```

### Run Tests in a Sibling Pane

```bash
herdr pane split 1-2 --direction down --no-focus
herdr pane run 1-3 "cargo test"
herdr wait output 1-3 --match "test result" --timeout 60000
herdr pane read 1-3 --source recent --lines 30
```

### Coordinate with Another Agent

```bash
# Wait for sibling agent to finish
herdr wait agent-status 1-1 --status done --timeout 120000

# Read their output
herdr pane read 1-1 --source recent --lines 100
```

### Spawn a New Agent Instance

```bash
herdr pane split 1-2 --direction right --no-focus
herdr pane run 1-3 "claude"
herdr wait output 1-3 --match ">" --timeout 15000

# Now give it a task
herdr pane run 1-3 "analyze the logs in src/"
```

### Watch a Pane Robustly

When coordinating with a specific pane:

```bash
# Inspect what is already there
herdr pane read 1-3 --source recent --lines 40

# Wait only for the next output you expect
herdr wait output 1-3 --match "ready" --timeout 30000

# If you need to inspect the transcript the waiter matched:
herdr pane read 1-3 --source recent-unwrapped --lines 40
```

## Notes

- `workspace list`, `tab list`, `pane list`, `wait output`, `wait agent-status` output JSON. Parse with `python3 -c 'import sys,json; ...'`.
- `pane read` outputs plain text.
- `pane read --format ansi` returns an ANSI snapshot for terminal feedback.
- Parse IDs from `create`/`split` responses:
  - `workspace create` → `result.workspace`, `result.tab`, `result.root_pane`
  - `tab create` → `result.tab`, `result.root_pane`
  - `pane split` → `result.pane.pane_id`
- `--no-focus` keeps your current context. Use it when spawning sibling work.
- `--label` names workspaces and tabs immediately.
- Use `pane read` for existing output. Use `wait output` for future output.
- IDs can shift; always re-query after closing items.
