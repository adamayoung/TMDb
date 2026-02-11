TARGET = TMDb
TEST_TARGET = TMDbTests
INTEGRATION_TEST_TARGET = TMDbIntegrationTests

IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 17,OS=26.2'
WATCHOS_DESTINATION = 'platform=watchOS Simulator,name=Apple Watch Series 11 (46mm),OS=26.2'
TVOS_DESTINATION = 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=26.2'
VISIONOS_DESTINATION = 'platform=visionOS Simulator,name=Apple Vision Pro,OS=26.2'

SWIFT_CONTAINER_IMAGE = swift:6.0.2-jammy

.PHONY: clean
clean:
	swift package clean
	rm -rf docs

.PHONY: format
format:
	@swiftlint --fix .
	@swiftformat .

.PHONY: lint format-check
lint format-check:
	@swiftlint --strict .
	@swiftformat --lint .

.PHONY: lint-markdown
lint-markdown:
	markdownlint "README.md"
	markdownlint "**/*.docc/**/*.md"

.PHONY: build
build:
	set -o pipefail && swift build -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-tests
build-tests:
	set -o pipefail && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-linux
build-linux:
	docker run --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build -Xswiftc -warnings-as-errors"

.PHONY: build-release
build-release:
	set -o pipefail && swift build -c release -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror

.PHONY: build-linux-release
build-linux-release:
	docker run --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build -c release -Xswiftc -warnings-as-errors"

.PHONY: build-docs
build-docs:
	SWIFTCI_DOCC=1 swift package generate-documentation --warnings-as-errors
	swift package resolve

.PHONY: preview-docs
preview-docs:
	SWIFTCI_DOCC=1 swift package --disable-sandbox preview-documentation --target $(TARGET)

.PHONY: generate-docs
generate-docs:
	SWIFTCI_DOCC=1 swift package --allow-writing-to-directory docs \
		generate-documentation --target $(TARGET) \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path $(TARGET) \
		--output-path docs

.PHONY: test
test:
	set -o pipefail && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 | xcsift -f toon --Werror
	set -o pipefail && swift test --skip-build --filter $(TEST_TARGET) 2>&1 | xcsift -f toon

.PHONY: test-linux
test-linux:
	docker run -i --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build --build-tests -Xswiftc -warnings-as-errors && swift test --skip-build --filter $(TEST_TARGET)"

.PHONY: integration-test
integration-test: .check-env-vars
	set -o pipefail && swift build --build-tests 2>&1 | xcsift -f toon
	set -o pipefail && swift test --skip-build --filter $(INTEGRATION_TEST_TARGET) 2>&1 | xcsift -f toon

.PHONY: ci
ci: .check-env-vars lint lint-markdown test integration-test build-release build-docs

.check-env-vars:
	@test $${TMDB_API_KEY?Please set environment variable TMDB_API_KEY}
	@test $${TMDB_USERNAME?Please set environment variable TMDB_USERNAME}
	@test $${TMDB_PASSWORD?Please set environment variable TMDB_PASSWORD}
