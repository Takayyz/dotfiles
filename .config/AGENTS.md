# Instructions for AI Coding Agents

## Most Important Rule
- Use `sequential-thinking` when executing tasks.

## Notes for Code Implementation
### TypeScript
- Do not use the `any` type for TypeScript type annotations.

## After Completing a Task
- Based on the changes made, update README.md and AGENTS.md to document the new features and their usage.

## Proactively Use Skills and Subagents
### How to Choose
- **Skill**: For tasks requiring specialized knowledge → Read SKILL.md before starting, then apply the procedures/constraints exactly. Don't just declare—actually follow through.
- **Subagent**: Delegate tasks where independent context is beneficial (refactoring, reviews, broad exploration, etc.), or when parallel execution is desired.

Note: Both can be used together. You may pass Skill knowledge to a Subagent for execution.
Note: For small tasks without a matching Skill/Subagent, proceed with the normal flow.

### Be Explicit When Using

State which Skill/Subagent you're using and why in one line before proceeding.
