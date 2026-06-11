---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

1. Run `/format` to format code
2. Check for formatting changes and commit them if needed with message "🤖 apply code formatting"
3. Run `make ci` — **MANDATORY; it must pass before going further.** This is the full gate CLAUDE.md requires before any PR: it runs lint, markdown lint, unit tests, integration tests, the release build, and the docs build. Run it directly (do not delegate). If it fails, stop and fix — never open a PR on a red gate.
4. Spawn the `code-reviewer` agent to perform a code review of all changes (pass the git diff output as context)
5. Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
6. If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
7. Check if branch is up-to-date with main (warn if behind)
8. Run `git status` and `git diff origin/main...HEAD` to understand all changes
9. Analyze the commits and changes to generate an appropriate title and summary
10. Push the current branch to remote if not already pushed
11. Create a PR using `gh pr create` with:
    - **IMPORTANT: Title MUST start with a gitmoji prefix** (e.g., "✨ Add new feature", "🐛 Fix bug", "📝 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
        - Common: ✨ feature, 🐛 bugfix, ♻️ refactor, ✅ tests, 📝 docs, 🔧 config, 🎨 style
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
