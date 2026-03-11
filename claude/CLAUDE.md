# Communication
- Respond in Japanese. Technical terms can remain in English.
- Be concise. Show code when possible instead of lengthy explanations.
- When the user says "レビューしました" or "確認しました", they are reporting completion — not requesting Claude to review.

# Process
- Before starting implementation, present the plan and scope of changes for confirmation.
- For changes spanning multiple files, list them before proceeding.
- Ask questions instead of making assumptions.
- Before entering plan mode, gather all requirements and constraints first. Finalize the plan in 1-2 iterations — do not cycle in and out of plan mode repeatedly.
- Before making changes, verify you are in the correct repository and directory by checking `pwd` and `git remote -v`.

# Git
- All commits must include a `Co-Authored-By` trailer with the actual model name: e.g. `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`. This applies to all commits, including those made via Bash `git commit`.

# Restrictions
- Never merge branches without explicit approval.
- Never push to main/master directly.
- Never delete files or branches without confirmation.
- Never run destructive commands (e.g. DROP, rm -rf) without confirmation.