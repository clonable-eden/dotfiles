#!/usr/bin/env bash
# Claude Code statusLine command
# Receives JSON via stdin and outputs a colorized, emoji-decorated 3-line status line

input=$(cat)

# ANSI color codes
RESET="\033[0m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"
BLUE="\033[34m"
WHITE="\033[97m"
DIM="\033[2m"
BOLD="\033[1m"

SEP="  ${DIM}│${RESET}  "

# Extract fields
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_name=$(echo "$input" | jq -r '.session_name // empty')
session_id=$(echo "$input" | jq -r '.session_id // empty')
version=$(echo "$input" | jq -r '.version // empty')

# Worktree fields (only present in --worktree sessions)
worktree_name=$(echo "$input" | jq -r '.worktree.name // empty')
worktree_branch=$(echo "$input" | jq -r '.worktree.branch // empty')
worktree_path=$(echo "$input" | jq -r '.worktree.path // empty')

# Shorten directory: keep last 3 components (mirrors starship truncation_length=3)
short_dir=$(echo "$cwd" | awk -F'/' '{
  n = NF
  if (n <= 3) { print $0 }
  else { print "…/" $(n-2) "/" $(n-1) "/" $n }
}')

# Git branch (skip lock files to avoid contention)
git_branch=""
if git -C "$cwd" rev-parse --git-dir &>/dev/null; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

# Context usage bar with color coding
ctx_part=""
if [[ -n "$used" && "$used" != "null" ]]; then
  used_int=${used%.*}
  if [[ $used_int -ge 90 ]]; then
    bar_color="$RED"
    bar="██████"
  elif [[ $used_int -ge 75 ]]; then
    bar_color="$RED"
    bar="█████░"
  elif [[ $used_int -ge 50 ]]; then
    bar_color="$YELLOW"
    bar="████░░"
  elif [[ $used_int -ge 25 ]]; then
    bar_color="$YELLOW"
    bar="███░░░"
  else
    bar_color="$GREEN"
    bar="██░░░░"
  fi
  ctx_part="📊 ${bar_color}${used_int}% ${bar}${RESET}"
fi

# Abbreviated session ID: first 8 chars
session_id_short=""
[[ -n "$session_id" ]] && session_id_short="${DIM}#${session_id:0:8}${RESET}"

# Version: dimmed
version_part=""
[[ -n "$version" ]] && version_part="${DIM}v${version}${RESET}"

# Worktree section (only when present)
worktree_part=""
if [[ -n "$worktree_name" ]]; then
  short_wt_path=$(echo "$worktree_path" | awk -F'/' '{
    n = NF
    if (n <= 3) { print $0 }
    else { print "…/" $(n-2) "/" $(n-1) "/" $n }
  }')
  worktree_part="${BLUE}🌳 ${worktree_name}${RESET}"
  [[ -n "$worktree_branch" ]] && worktree_part="${worktree_part} ${DIM}(${worktree_branch})${RESET}"
  worktree_part="${worktree_part} ${DIM}@ ${short_wt_path}${RESET}"
fi

# ── Line 1: 👤 user@host  │  📂 directory
line1="${CYAN}${BOLD}👤 $(whoami)@$(hostname -s)${RESET}"
line1="${line1}${SEP}${GREEN}📂 ${short_dir}${RESET}"

# ── Line 2: 🌿 branch  [│  🌳 worktree name (branch) @ path]
line2="${YELLOW}🌿 ${git_branch:-HEAD}${RESET}"
[[ -n "$worktree_part" ]] && line2="${line2}${SEP}${worktree_part}"

# ── Line 3: 🔑 session_id  [│  "session name"]
line3="${WHITE}🔑 ${session_id:0:8}${RESET}"
[[ -n "$session_name" ]] && line3="${line3}${SEP}${WHITE}\"${session_name}\"${RESET}"

# ── Line 4: ✦ version  │  🤖 model  │  📊 context
line4="${CYAN}✦ ${version:-?}${RESET}"
[[ -n "$model" ]]    && line4="${line4}${SEP}${MAGENTA}🤖 ${model}${RESET}"
[[ -n "$ctx_part" ]] && line4="${line4}${SEP}${ctx_part}"

printf "%b\n%b\n%b\n%b" "$line1" "$line2" "$line3" "$line4"
