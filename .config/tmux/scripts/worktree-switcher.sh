#!/usr/bin/env bash
#
# worktree-switcher.sh
# fzf でブランチを選択し、gwq で worktree を作成、tmux セッションに切り替える
#

set -euo pipefail

#========================================
# Constants
#========================================
readonly CREATE_NEW_BRANCH="[+] Create new branch"
readonly FZF_HEIGHT="80%"
readonly FZF_PREVIEW_COMMITS=20

#========================================
# Functions
#========================================

# エラー終了
die() {
  echo "Error: $1" >&2
  exit 1
}

# Git リポジトリ内かチェック
check_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null || die "Not inside a git repository"
}

# リポジトリ名を取得（ベアリポジトリ対応）
get_repo_name() {
  local repo_root
  repo_root=$(git rev-parse --git-dir 2>/dev/null)

  if [[ "$repo_root" == "." ]]; then
    # ベアリポジトリの場合
    basename "$(pwd)"
  else
    basename "$(git rev-parse --show-toplevel 2>/dev/null || dirname "$repo_root")"
  fi
}

# 既存 worktree のブランチ一覧を取得
get_worktree_branches() {
  if command -v gwq &>/dev/null; then
    gwq list --json 2>/dev/null | jq -r '.[].branch // empty' 2>/dev/null | sed 's|^refs/heads/||'
  else
    git worktree list --porcelain 2>/dev/null | grep '^branch ' | sed 's|^branch refs/heads/||'
  fi
}

# ローカルブランチ一覧を取得（worktree にあるものを除く）
get_local_branches() {
  local worktree_branches="$1"
  git branch --format='%(refname:short)' 2>/dev/null | while read -r branch; do
    if ! echo "$worktree_branches" | grep -qx "$branch"; then
      echo "$branch"
    fi
  done
}

# リモートブランチ一覧を取得（ローカルに存在しないもの）
get_remote_branches() {
  local all_local="$1"
  git branch -r --format='%(refname:short)' 2>/dev/null | \
    sed 's|^origin/||' | \
    grep -v '^HEAD$' | \
    while read -r branch; do
      if ! echo "$all_local" | grep -qx "$branch"; then
        echo "$branch"
      fi
    done
}

# ブランチ一覧を優先度順に生成
build_branch_list() {
  local worktree_branches local_branches all_local

  # 1. 既存 worktree のブランチ（プレフィックス付き）
  worktree_branches=$(get_worktree_branches)
  if [[ -n "$worktree_branches" ]]; then
    echo "$worktree_branches" | while read -r branch; do
      echo "[worktree] $branch"
    done
  fi

  # 2. ローカルブランチ
  local_branches=$(get_local_branches "$worktree_branches")
  if [[ -n "$local_branches" ]]; then
    echo "$local_branches" | while read -r branch; do
      echo "[local] $branch"
    done
  fi

  # 3. リモートブランチ
  all_local=$(printf '%s\n%s' "$worktree_branches" "$local_branches" | sort -u)
  remote_branches=$(get_remote_branches "$all_local")
  if [[ -n "$remote_branches" ]]; then
    echo "$remote_branches" | while read -r branch; do
      echo "[remote] $branch"
    done
  fi

  # 4. 新規ブランチ作成オプション
  echo "$CREATE_NEW_BRANCH"
}

# fzf でブランチを選択
select_branch() {
  local branch_list="$1"

  echo "$branch_list" | fzf \
    --height="$FZF_HEIGHT" \
    --reverse \
    --prompt="Select branch > " \
    --header="[worktree]=existing, [local]=local only, [remote]=remote only" \
    --preview="git log --oneline --graph -n $FZF_PREVIEW_COMMITS {-1} 2>/dev/null || echo 'No commits yet'" \
    --preview-window=right:50%
}

# 新規ブランチ名を入力
input_new_branch() {
  local branch_name
  echo -n "Enter new branch name: " >&2
  read -r branch_name

  [[ -z "$branch_name" ]] && die "Branch name cannot be empty"
  echo "$branch_name"
}

# worktree のパスを取得または作成
get_or_create_worktree() {
  local branch="$1"
  local worktree_path

  # 既存の worktree を確認
  if command -v gwq &>/dev/null; then
    worktree_path=$(gwq list --json 2>/dev/null | jq -r --arg b "$branch" '.[] | select(.branch == "refs/heads/\($b)" or .branch == $b) | .path // empty' 2>/dev/null | head -1)
  fi

  if [[ -z "$worktree_path" ]]; then
    # git worktree list からも確認
    worktree_path=$(git worktree list --porcelain 2>/dev/null | awk -v branch="$branch" '
      /^worktree / { path=$2 }
      /^branch refs\/heads\// { if ($2 == "refs/heads/"branch) print path }
    ')
  fi

  if [[ -n "$worktree_path" && -d "$worktree_path" ]]; then
    echo "$worktree_path"
    return
  fi

  # worktree を作成
  echo "Creating worktree for branch: $branch" >&2
  if command -v gwq &>/dev/null; then
    gwq add "$branch" >&2
    # 作成後のパスを取得
    worktree_path=$(gwq list --json 2>/dev/null | jq -r --arg b "$branch" '.[] | select(.branch == "refs/heads/\($b)" or .branch == $b) | .path // empty' 2>/dev/null | head -1)
  else
    die "gwq command not found. Please install git-worktree-query."
  fi

  [[ -z "$worktree_path" ]] && die "Failed to create worktree for branch: $branch"
  echo "$worktree_path"
}

# tmux セッションを作成または切り替え
switch_tmux_session() {
  local repo_name="$1"
  local branch="$2"
  local worktree_path="$3"

  # セッション名を生成（スラッシュをアンダースコアに変換）
  local session_name="${repo_name}-${branch//\//_}"

  # 既存セッションがあるか確認
  if tmux has-session -t "=$session_name" 2>/dev/null; then
    echo "Switching to existing session: $session_name" >&2
    tmux switch-client -t "=$session_name"
  else
    echo "Creating new session: $session_name" >&2
    tmux new-session -d -s "$session_name" -c "$worktree_path"
    tmux switch-client -t "=$session_name"
  fi
}

#========================================
# Main
#========================================
main() {
  check_git_repo

  local repo_name branch_list selected branch worktree_path

  repo_name=$(get_repo_name)
  branch_list=$(build_branch_list)

  # fzf でブランチを選択
  selected=$(select_branch "$branch_list") || exit 0

  # 選択結果を処理
  if [[ "$selected" == "$CREATE_NEW_BRANCH" ]]; then
    branch=$(input_new_branch)
  else
    # プレフィックスを除去してブランチ名を取得
    branch=$(echo "$selected" | sed 's/^\[[^]]*\] //')
  fi

  # worktree を取得または作成
  worktree_path=$(get_or_create_worktree "$branch")

  # tmux セッションを作成/切り替え
  switch_tmux_session "$repo_name" "$branch" "$worktree_path"
}

main "$@"
