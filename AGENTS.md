# Communication
- Respond in Japanese. Technical terms can remain in English.
- Be concise. Show code when possible instead of lengthy explanations.
- When the user says "レビューしました" or "確認しました", they are reporting completion — not requesting the agent to review.

# Process
- Before starting implementation, present the plan and scope of changes for confirmation.
- For changes spanning multiple files, list them before proceeding.
- Ask questions instead of making assumptions.
- Before entering plan mode, gather all requirements and constraints first. Finalize the plan in 1-2 iterations — do not cycle in and out of plan mode repeatedly.
- Before making changes, verify you are in the correct repository and directory by checking `pwd` and `git remote -v`.

# Coding
- Do not write unnecessary code comments. Rationale ("why this value / this design") belongs in issues, PR descriptions, or commit messages — not in code.
- Write comments only for constraints or warnings that cannot be expressed in code (e.g. functional directives like `tfsec:ignore`, known pitfalls).

# Git
- All AI-authored commits must include a `Co-Authored-By` trailer with the actual agent and model name. This applies to all commits, including those made via Bash `git commit`.
- Do not include AI session URLs or identifiers in commit messages. Session URLs are sensitive and must not be written to git history.

# Restrictions
- Never merge branches without explicit approval.
- Never push to main/master directly.
- Never delete files or branches without confirmation.
- Never run destructive commands (e.g. DROP, rm -rf) without confirmation.
