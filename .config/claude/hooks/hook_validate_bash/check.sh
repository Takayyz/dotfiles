#!/bin/bash
# PreToolUse hook: Validate Bash commands before execution
# Denies forbidden commands with a reason so Claude understands why and stops retrying.

input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only validate Bash tool
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

RULES_PATH="$HOME/.claude/hooks/hook_validate_bash/rules.json"

if [[ ! -f "$RULES_PATH" ]]; then
  exit 0
fi

# Loop through rules and check each pattern
rule_count=$(jq 'length' "$RULES_PATH")
for ((i = 0; i < rule_count; i++)); do
  pattern=$(jq -r ".[$i].pattern" "$RULES_PATH")
  decision=$(jq -r ".[$i].decision // \"deny\"" "$RULES_PATH")
  reason=$(jq -r ".[$i].reason" "$RULES_PATH")

  if echo "$command" | grep -qE "$pattern"; then
    jq -n --arg decision "$decision" --arg reason "$reason" '{
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": $decision,
        "permissionDecisionReason": $reason
      }
    }'
    exit 0
  fi
done

exit 0
