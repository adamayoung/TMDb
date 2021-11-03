# Variables

SHELL := /bin/bash
OS_NAME := $(shell uname -s | tr A-Z a-z)
DOCKER_SWIFT_VERSION := 5.5
SCHEME := TMDb
SONARCLOUD_PROJECT_KEY := adamayoung_TMDb


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
	@swift build

build-ios:
	@echo "Building for iOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 12 Pro,OS=15.0' \
		build

build-watchos:
	@echo "Building for watchOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk watchsimulator \
		-destination 'platform=watchOS Simulator,name=Apple Watch Series 6 - 44mm,OS=8.0' \
		build

build-linux:
	@echo "Building for Linux..."
	@if [ "$(OS_NAME)" == "darwin" ]; then \
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:"$(DOCKER_SWIFT_VERSION)" /bin/bash -c "swift build --build-path ./.build/linux"; \
	else \
		make build; \
	fi


# Test

test-all: test-macos test-ios test-watchos test-linux

test:
	@echo "Testing for current platform..."
	@swift test

test-macos:
	@echo "Testing for macOS..."
	@swift test

test-ios:
	@echo "Testing for iOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 12 Pro,OS=15.0' \
		test

test-watchos:
	@echo "Testing for watchOS..."
	@xcodebuild \
		-scheme "$(SCHEME)" \
		-sdk watchsimulator \
		-destination 'platform=watchOS Simulator,name=Apple Watch Series 6 - 44mm,OS=8.0' \
		test

test-linux:
	@echo "Testing for Linux..."
	ifeq ($(OS_NAME), darwin)
		docker run --rm --privileged --interactive --tty -v "$$(pwd):/src" -w "/src" swift:"$(DOCKER_SWIFT_VERSION)" /bin/bash -c "swift test --build-path ./.build/linux"
	else
		make test
	endif


# Analyse

analyse:
	@echo "Analysing for SonarCloud..."
	$(call brew_install,swiftlint)
	$(call brew_install,sonar-scanner)
	@set -o pipefail && swiftlint --reporter json > swiftlint.result.json
	@set -o pipefail && swift test --enable-code-coverage
	@xcrun llvm-cov show ".build/debug/$(SCHEME)PackageTests.xctest/Contents/MacOS/$(SCHEME)PackageTests" -instr-profile ".build/debug/codecov/default.profdata" "Sources/" > info.lcov
	@sonar-scanner -Dsonar.projectKey="$(SONARCLOUD_PROJECT_KEY)" -Dsonar.organization=adamayoung -Dsonar.host.url="https://sonarcloud.io" -Dsonar.sources=Sources -Dsonar.swift.coverage.reportPaths=info.lcov -Dsonar.swift.swiftLint.reportPaths=swiftlint.result.json


# Functions

define brew_install
	@if which $(1) >/dev/null; then \
  		echo "$(1) installed..."; \
	else \
		echo "Installing $(1)..."; \
  		brew install $(1); \
	fi
endef
