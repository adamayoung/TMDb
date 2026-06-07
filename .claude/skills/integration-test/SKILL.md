---
name: integration-test
description: Run integration tests against the live TMDb API
---

# Run integration tests

Run `make integration-test` from the project root.

This requires `TMDB_API_KEY`, `TMDB_USERNAME`, and `TMDB_PASSWORD` environment variables to be set. These are injected automatically via the `env` block in `.claude/settings.local.json`, so no sourcing is needed.
