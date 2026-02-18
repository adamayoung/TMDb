---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

1. Run `/format` to format code
2. Check for formatting changes and commit them if needed with message "🤖 apply code formatting"
3. Run `/lint` to verify code style and quality
4. Run `/build-for-testing` to ensure project builds successfully with no warnings
5. Run `/test` to verify all unit tests pass
6. Run `/integration-test` to verify all integration tests pass
7. Spawn the `code-reviewer` agent to perform a code review of all changes (pass the git diff output as context)
8. Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
9. If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
10. Check if branch is up-to-date with main (warn if behind)
11. Run `git status` and `git diff origin/main...HEAD` to understand all changes
12. Analyze the commits and changes to generate an appropriate title and summary
13. Push the current branch to remote if not already pushed
14. Create a PR using `gh pr create` with:
    - **IMPORTANT: Title MUST start with a gitmoji prefix** (e.g., "✨ Add new feature", "🐛 Fix bug", "📚 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
        - Common: ✨ feature, 🐛 bugfix, ♻️ refactor, 🧪 tests, 📚 docs, 🔧 config, 🎨 style
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
