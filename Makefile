TARGET = TMDb
TEST_TARGET = TMDbTests
INTEGRATION_TEST_TARGET = TMDbIntegrationTests

IOS_DESTINATION = 'platform=iOS Simulator,name=iPhone 15,OS=18.0'
WATCHOS_DESINTATION = 'platform=watchOS Simulator,name=Apple Watch Series 9 (45mm),OS=11.0'
TVOS_DESTINATION = 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation),OS=18.0'
VISIONOS_DESTINATION = 'platform=visionOS Simulator,name=Apple Vision Pro,OS=2.0'

SWIFT_CONTAINER_IMAGE = swiftlang/swift:nightly-6.0-jammy

.PHONY: clean
clean:
	swift package clean
	rm -rf docs

.PHONY: format
format:
	swiftlint --fix
	swiftformat .

.PHONY: lint
lint:
	swiftlint --strict
	swiftformat --lint .

.PHONY: lint-markdown
lint-markdown:
	markdownlint "README.md"
	markdownlint "**/*.docc/**/*.md"

.PHONY: build
build:
	swift build -Xswiftc -warnings-as-errors

.PHONY: build-tests
build-tests:
	swift build --build-tests -Xswiftc -warnings-as-errors

.PHONY: build-linux
build-linux:
	docker run --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build -Xswiftc -warnings-as-errors

.PHONY: build-release
build-release:
	swift build -c release -Xswiftc -warnings-as-errors

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
	swift build --build-tests -Xswiftc -warnings-as-errors
	swift test --skip-build --filter $(TEST_TARGET)

.PHONY: test-ios
test-ios:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild clean build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(IOS_DESTINATION)

.PHONY: test-watchos
test-watchos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(WATCHOS_DESINTATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(WATCHOS_DESINTATION)

.PHONY: test-tvos
test-tvos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(TVOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(TVOS_DESTINATION)

.PHONY: test-visionos
test-visionos:
	set -o pipefail && NSUnbufferedIO=YES xcodebuild build-for-testing -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(VISIONOS_DESTINATION)
	set -o pipefail && NSUnbufferedIO=YES xcodebuild test-without-building -scheme $(TARGET) -only-testing $(TEST_TARGET) -destination $(VISIONOS_DESTINATION)

.PHONY: test-linux
test-linux:
	docker run -i --rm -v "$${PWD}:/workspace" -w /workspace $(SWIFT_CONTAINER_IMAGE) /bin/bash -cl "swift build --build-tests -Xswiftc -warnings-as-errors && swift test --skip-build --filter $(TEST_TARGET)"

.PHONY: integration-test
integration-test: .check-env-vars
	swift build --build-tests
	swift test --skip-build --filter $(INTEGRATION_TEST_TARGET)

.PHONY: ci
ci: .check-env-vars lint lint-markdown test test-ios test-watchos test-tvos test-visionos integration-test build-release build-docs

.check-env-vars:
	@test $${TMDB_API_KEY?Please set environment variable TMDB_API_KEY}
	@test $${TMDB_USERNAME?Please set environment variable TMDB_USERNAME}
	@test $${TMDB_PASSWORD?Please set environment variable TMDB_PASSWORD}
