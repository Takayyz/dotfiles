---
name: find-skills
description: Helps discover, evaluate, and install agent skills using the `gh skill` command (GitHub CLI). Use when the user asks "is there a skill for X", "find a skill that does Y", "how do I do X" where X might already exist as a skill, or expresses interest in extending agent capabilities.
---

# Find Skills

Discover and install skills using `gh skill` (GitHub CLI's built-in skill manager, currently in preview).

## Core commands

- `gh skill search <query>` — search for skills across GitHub by keyword
- `gh skill preview <repo> <skill>` — view a skill's SKILL.md content before installing
- `gh skill install <repo> [<skill>]` — install a skill (prompts interactively if skill/agent are omitted)
- `gh skill list` — list installed skills across known agent hosts
- `gh skill update [<skill>...]` — update installed skills to their latest version

## Workflow

1. Search: `gh skill search <keywords>` to find candidates. Prefer repos/skills with meaningful adoption (shown as a trailing count in search results) over obscure ones, all else equal.
2. **Always preview before installing**: `gh skill preview <repo> <skill>` and actually read the content. `gh skill` itself warns that skills are not verified by GitHub and may contain prompt injections, hidden instructions, or malicious scripts — do not skip this step.
3. Install: `gh skill install <repo> <skill> --agent <agent> --scope <project|user>`.
   - Default scope is `project`. Use `--scope user` for skills that should be available everywhere, not just this repo.
   - `--agent` controls the destination directory. At project scope, several agents (GitHub Copilot, Cursor, Codex, Gemini CLI, Antigravity, Amp, Cline, OpenCode, Warp) share `.agents/skills/`. Claude Code does not read `.agents/skills` natively — it only reads `.claude/skills/` — but in this dotfiles repo, `~/.claude/skills` is symlinked directly to `.agents/skills`, so installing with `--agent claude-code` (or any of the shared-destination agents, since they land in the same place) works for Claude Code too.
4. To check for updates later: `gh skill update` (add `--dry-run` to preview without changing files).

## Notes

- `gh skill install --dir <path>` overrides the agent/scope resolution entirely if a custom destination is needed, but this also affects how `gh skill list`/`update` discover the skill afterward (they scan known agent-host directories, not arbitrary custom paths) — prefer `--agent`/`--scope` over `--dir` unless there's a specific reason not to.
- `gh skill` does not follow symlinks when scanning for installed skills. Always run `gh skill update` against the real skill directory (`.agents/skills` in this repo), not through a symlinked path.
