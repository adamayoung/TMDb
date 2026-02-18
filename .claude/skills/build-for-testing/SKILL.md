---
name: build-for-testing
description: Build the project for testing
---

# Build for testing

Run `make build-tests` from the project root.

This differs from `/build` (`make build`) in that it also compiles all test targets, ensuring they build cleanly before running tests. Both use warnings-as-errors.

If the build fails, review the output for error details.
