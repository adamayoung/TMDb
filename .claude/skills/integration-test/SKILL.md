---
name: integration-test
description: Run integration tests against the live TMDb API
---

# Run integration tests

Run `source ~/.zshrc 2>/dev/null && make integration-test` from the project root.

This requires `TMDB_API_KEY`, `TMDB_USERNAME`, and `TMDB_PASSWORD` environment variables to be set. Sourcing `.zshrc` ensures they are available.
