TARGET = TMDb
TEST_TARGET = TMDbTests|TMDbTestingTests|TMDbIntelligenceTests|TMDbIntelligenceTestingTests
INTEGRATION_TEST_TARGET = TMDbIntegrationTests

IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 17 Pro,OS=27.0'
WATCHOS_DESTINATION = 'platform=watchOS Simulator,name=Apple Watch Series 11 (46mm),OS=27.0'
TVOS_DESTINATION = 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=27.0'
VISIONOS_DESTINATION = 'platform=visionOS Simulator,name=Apple Vision Pro,OS=27.0'

SWIFT_CONTAINER_IMAGE = swift:6.1-jammy

# SwiftPM scratch (build) directory — the swift-build equivalent of Xcode's
# DerivedData. Override to isolate concurrent builds across git worktrees, e.g.
# `make test SCRATCH_PATH=.build/agent-a` (stays under the gitignored .build).
SCRATCH_PATH ?= .build

# Documentation builds get their OWN scratch directory, and must keep it.
#
# Package.swift branches on SWIFTCI_DOCC: the =1 path adds the swift-docc-plugin
# dependency, the else path sets `exclude` on the four .docc-bearing targets.
# Those are two different dependency graphs *and* two different per-target source
# lists. Pointing both at one scratch directory makes every switch between a docs
# build and any other target re-resolve and rebuild — and under concurrency it is
# worse than slow: a docs build re-resolves the manifest out from under an
# in-flight build, so the two then contend on .build/.lock repeatedly redoing
# work the other invalidated.
DOCS_SCRATCH_PATH ?= $(SCRATCH_PATH)/docs

.PHONY: clean
clean:
	swift package --scratch-path $(SCRATCH_PATH) clean
	rm -rf $(DOCS_SCRATCH_PATH)
	rm -rf docs

.PHONY: format
format:
	@swiftlint --fix .
	@swiftformat .

.PHONY: lint
lint: lint-witnesses
	@swiftlint --strict .
	@swiftformat --lint .

# Cross-symbol check that swiftlint cannot express: a public-extension
# convenience must not share a requirement's signature (see the script, and
# knowledge/gotchas.md).
#
# NO WORKFLOW RUNS `make`. The CI Lint job invokes swiftlint/swiftformat as
# inline steps, so a check wired only here never reaches CI and green means
# "nobody looked". This one is mirrored as the `Defaulted-witness check` step in
# .github/workflows/ci.yml. Adding a check? Wire it in BOTH places, and add its
# inputs to the `changes` paths filter, or a PR touching only that input skips
# the whole job that runs it.
.PHONY: lint-witnesses
lint-witnesses:
	@python3 Scripts/check-defaulted-witnesses.py

.PHONY: lint-markdown
lint-markdown:
	markdownlint "README.md" "CLAUDE.md"
	markdownlint "**/*.docc/**/*.md"
	markdownlint ".claude/**/*.md"
	markdownlint "knowledge/**/*.md"

.PHONY: build
build:
	set -o pipefail && swift build --scratch-path $(SCRATCH_PATH) -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-tests
build-tests:
	set -o pipefail && swift build --build-tests --scratch-path $(SCRATCH_PATH) -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-linux
build-linux:
	docker run --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build -Xswiftc -warnings-as-errors"

.PHONY: build-release
build-release:
	set -o pipefail && swift build -c release --scratch-path $(SCRATCH_PATH) -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-linux-release
build-linux-release:
	docker run --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build -c release -Xswiftc -warnings-as-errors"

.PHONY: build-docs
build-docs:
	SWIFTCI_DOCC=1 swift package --scratch-path $(DOCS_SCRATCH_PATH) generate-documentation --warnings-as-errors

.PHONY: preview-docs
preview-docs:
	SWIFTCI_DOCC=1 swift package --scratch-path $(DOCS_SCRATCH_PATH) --disable-sandbox preview-documentation --target $(TARGET)

.PHONY: generate-docs
generate-docs:
	SWIFTCI_DOCC=1 swift package --scratch-path $(DOCS_SCRATCH_PATH) --allow-writing-to-directory docs \
		generate-documentation \
		--target TMDb \
		--target TMDbIntelligence \
		--target TMDbTesting \
		--target TMDbIntelligenceTesting \
		--enable-experimental-combined-documentation \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path $(TARGET) \
		--output-path docs

.PHONY: test
test:
	set -o pipefail && swift build --build-tests --scratch-path $(SCRATCH_PATH) -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror
	set -o pipefail && swift test --skip-build --scratch-path $(SCRATCH_PATH) --filter "$(TEST_TARGET)" 2>&1 | xcsift -f toon

.PHONY: test-linux
test-linux:
	docker run -i --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build --build-tests -Xswiftc -warnings-as-errors && swift test --skip-build --filter '$(TEST_TARGET)'"

.PHONY: integration-test
integration-test: .check-env-vars
	set -o pipefail && swift build --build-tests --scratch-path $(SCRATCH_PATH) 2>&1 | xcsift -f toon
	set -o pipefail && swift test --skip-build --scratch-path $(SCRATCH_PATH) --filter $(INTEGRATION_TEST_TARGET) 2>&1 | xcsift -f toon

.PHONY: ci
ci: .check-env-vars lint lint-markdown test integration-test build-release build-docs

.check-env-vars:
	@test $${TMDB_API_KEY?Please set environment variable TMDB_API_KEY}
	@test $${TMDB_USERNAME?Please set environment variable TMDB_USERNAME}
	@test $${TMDB_PASSWORD?Please set environment variable TMDB_PASSWORD}
# The v4 credentials warn rather than fail: the suites needing them self-gate
# with `.enabled(if:)`, so a contributor without them must still be able to run
# `make ci` to green.
	@test -n "$${TMDB_API_READ_ONLY_TOKEN:-}" || \
		echo "warning: TMDB_API_READ_ONLY_TOKEN not set — v4 suites will skip"
	@test -n "$${TMDB_API_USER_TOKEN:-}" || \
		echo "warning: TMDB_API_USER_TOKEN not set — v4 list suites will skip"
