OS_NAME := $(shell uname -s | tr A-Z a-z)

# Lint
lint:
	@brew ls --versions swiftlint || brew install swiftlint
	@swiftlint --strict

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
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:5.4 /bin/bash -c "swift test --build-path ./.build/linux"; \
	else \
		make test; \
	fi

analyse:
	@brew ls --versions swiftlint || brew install swiftlint
	@brew ls --versions sonar-scanner || brew install sonar-scanner
	@set -o pipefail && swiftlint --reporter json > swiftlint.result.json
	@set -o pipefail && swift test --enable-code-coverage
	@xcrun llvm-cov show ".build/debug/TMDbPackageTests.xctest/Contents/MacOS/TMDbPackageTests" -instr-profile ".build/debug/codecov/default.profdata" "Sources/" > info.lcov
	@sonar-scanner -Dsonar.projectKey=adamayoung_TMDb -Dsonar.organization=adamayoung -Dsonar.host.url="https://sonarcloud.io" -Dsonar.sources=Sources -Dsonar.swift.coverage.reportPaths=info.lcov -Dsonar.swift.swiftLint.reportPaths=swiftlint.result.json
