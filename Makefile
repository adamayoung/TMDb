SHELL := /bin/bash
OS_NAME := $(shell uname -s | tr A-Z a-z)
DOCKER_SWIFT_VERSION := 5.4

# Lint
lint:
	$(call install_swiftlint) && swiftlint --strict

# Test
test:
	@swift test

test-macos: test

test-ios:
	@xcodebuild \
		-scheme TMDb \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 12 Pro,OS=15.0' \
		test

test-watchos:
	@xcodebuild \
		-scheme TMDb \
		-sdk watchsimulator \
		-destination 'platform=watchOS Simulator,name=Apple Watch Series 6 - 44mm,OS=8.0' \
		test

test-linux:
	@if [ "$(OS_NAME)" == "darwin" ]; then \
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:"$(DOCKER_SWIFT_VERSION)" /bin/bash -c "swift test --build-path ./.build/linux"; \
	else \
		make test; \
	fi

analyse:
	$(call install_swiftlint)
	$(call install_sonar-scanner)
	@set -o pipefail && swiftlint --reporter json > swiftlint.result.json
	@set -o pipefail && swift test --enable-code-coverage
	@xcrun llvm-cov show ".build/debug/TMDbPackageTests.xctest/Contents/MacOS/TMDbPackageTests" -instr-profile ".build/debug/codecov/default.profdata" "Sources/" > info.lcov
	@sonar-scanner -Dsonar.projectKey=adamayoung_TMDb -Dsonar.organization=adamayoung -Dsonar.host.url="https://sonarcloud.io" -Dsonar.sources=Sources -Dsonar.swift.coverage.reportPaths=info.lcov -Dsonar.swift.swiftLint.reportPaths=swiftlint.result.json

define install_swiftlint
	@if which swiftlint >/dev/null; then \
  		echo "swiftlint installed..."; \
	else \
		echo "Installing swiftlint..."; \
  		brew install swiftlint; \
	fi
endef

define install_sonar-scanner
	@if which sonar-scanner >/dev/null; then \
  		echo "sonar-scanner installed..."; \
	else \
		echo "Installing sonar-scanner..."; \
  		brew install sonar-scanner; \
	fi
endef