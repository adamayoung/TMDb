# Variables

SHELL := /bin/bash
OS_NAME := $(shell uname -s | tr A-Z a-z)
DOCKER_SWIFT_VERSION := 5.5
SCHEME := TMDb
MAC_SDK := macosx12.1
MAC_DESTINATION := 'platform=macOS,arch=x86_64'
IPHONE_DESTINATION := 'platform=iOS Simulator,name=iPhone 13 Pro,OS=15.2'
WATCH_DESTINATION := 'platform=watchOS Simulator,name=Apple Watch Series 7 - 45mm,OS=8.3'
TV_DESTINATION := 'platform=tvOS Simulator,name=Apple TV 4K (2nd generation),OS=15.2'
SONARCLOUD_ORGANISATION := adamayoung
SONARCLOUD_PROJECT_NAME := TMDb


# Lint
lint:
	$(call brew_install,swiftlint) && swiftlint --strict

# Clean
clean:
	@rm -rf .build
	@rm -f swiftlint.result.json
	@rm -f info.lcov


# Build

build-all: build-macos build-ios build-watchos build-linux

build:
	@echo "Building for current platform..."
	@swift build

build-macos:
	@echo "Building for macOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk $(MAC_SDK) \
		-destination $(MAC_DESTINATION) \
		clean build

build-ios:
	@echo "Building for iOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk iphonesimulator \
		-destination $(IPHONE_DESTINATION) \
		clean build

build-watchos:
	@echo "Building for watchOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk watchsimulator \
		-destination $(WATCH_DESTINATION) \
		clean build

build-tvos:
	@echo "Building for tvOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk appletvsimulator \
		-destination $(TV_DESTINATION) \
		clean build

build-linux:
	@echo "Building for Linux..."
	@if [ "$(OS_NAME)" == "darwin" ]; then \
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:$(DOCKER_SWIFT_VERSION)-focal /bin/bash -c "swift build --build-path ./.build/linux"; \
	else \
		make build; \
	fi


# Test

test-all: test-macos test-ios test-watchos test-linux

test:
	@echo "Testing for current platform..."
	@swift test --parallel

test-macos:
	@echo "Testing for macOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk $(MAC_SDK) \
		-destination $(MAC_DESTINATION) \
		-parallel-testing-enabled YES \
		test

test-ios:
	@echo "Testing for iOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk iphonesimulator \
		-destination $(IPHONE_DESTINATION) \
		-parallel-testing-enabled YES \
		test

test-watchos:
	@echo "Testing for watchOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk watchsimulator \
		-destination $(WATCH_DESTINATION) \
		-parallel-testing-enabled YES \
		test

test-tvos:
	@echo "Testing for tvOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk appletvsimulator \
		-destination $(TV_DESTINATION) \
		-parallel-testing-enabled YES \
		test

test-linux:
	@echo "Testing for Linux..."
	@if [ "$(OS_NAME)" == "darwin" ]; then \
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:$(DOCKER_SWIFT_VERSION)-focal /bin/bash -c "swift test  --parallel --build-path ./.build/linux"; \
	else \
		make test; \
	fi


# Analyse

analyse:
	@echo "Analysing for SonarCloud..."
	$(call brew_install,swiftlint)
	$(call brew_install,sonar-scanner)
	@set -o pipefail && swiftlint --reporter json > swiftlint.result.json
	@set -o pipefail && xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk iphonesimulator \
		-destination $(IPHONE_DESTINATION) \
		-derivedDataPath Build/ \
		-enableCodeCoverage YES \
		clean build test
	@bash xccov-to-sonarqube-generic.sh Build/Logs/Test/*.xcresult/ > sonarqube-generic-coverage.xml
	@sonar-scanner -Dsonar.projectKey=$(SONARCLOUD_ORGANISATION)_$(SONARCLOUD_PROJECT_NAME) -Dsonar.organization=$(SONARCLOUD_ORGANISATION) -Dsonar.host.url="https://sonarcloud.io" -Dsonar.sources=Sources -Dsonar.coverageReportPaths=sonarqube-generic-coverage.xml -Dsonar.swift.swiftLint.reportPaths=swiftlint.result.json -Dsonar.cfamily.build-wrapper-output.bypass=true


# Test Docs

DOC_WARNINGS := $(shell xcodebuild clean docbuild \
	-scheme "$(SCHEME)" \
	-sdk $(MAC_SDK) \
	-destination $(MAC_DESTINATION) \
	-quiet \
	2>&1 \
	| grep "couldn't be resolved to known documentation" \
	| sed 's|$(PWD)|.|g' \
	| tr '\n' '\1')
test-docs:
	@test "$(DOC_WARNINGS)" = "" \
		|| (echo "xcodebuild docbuild failed:\n\n$(DOC_WARNINGS)" | tr '\1' '\n' \
		&& exit 1)

#analyse:
#	@echo "Analysing for SonarCloud..."
#	$(call brew_install,swiftlint)
#	$(call brew_install,sonar-scanner)
#	@set -o pipefail && swiftlint --reporter json > swiftlint.result.json
#	@set -o pipefail && swift test --enable-code-coverage
#	@xcrun llvm-cov show .build/debug/TMDbPackageTests.xctest/Contents/MacOS/TMDbPackageTests -instr-profile .build/debug/codecov/default.profdata Sources/ > info.lcov
#	@sonar-scanner -Dsonar.projectKey=$(SONARCLOUD_ORGANISATION)_$(SONARCLOUD_PROJECT_NAME) -Dsonar.organization=$(SONARCLOUD_ORGANISATION) -Dsonar.host.url="https://sonarcloud.io" -Dsonar.sources=Sources -Dsonar.swift.coverage.reportPaths=info.lcov -Dsonar.swift.swiftLint.reportPaths=swiftlint.result.json


# Functions

define brew_install
	@if which $(1) >/dev/null; then \
  		echo "$(1) installed..."; \
	else \
		echo "Installing $(1)..."; \
  		brew install $(1); \
	fi
endef
