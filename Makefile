# Variables

SCHEME := TMDb
MAC_SDK := macosx12.1
MAC_DESTINATION := 'platform=macOS,arch=x86_64'

# Test Documentation

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
