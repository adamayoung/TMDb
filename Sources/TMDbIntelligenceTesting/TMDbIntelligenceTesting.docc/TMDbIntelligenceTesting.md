# ``TMDbIntelligenceTesting``

Test doubles and sample data for testing code that depends on TMDbIntelligence.

## Overview

`TMDbIntelligenceTesting` is a companion library to `TMDbIntelligence` for use
in **test targets**. It provides a spy + stub mock for the natural-language
search service, plus real-data sample models, so you can test code that depends
on on-device intelligence without invoking the on-device models.

Add it as a dependency of your test target only:

```swift
.testTarget(
    name: "MyAppTests",
    dependencies: ["MyApp", "TMDbIntelligenceTesting"]
)
```

### Mock service

`MockNaturalLanguageSearchService` records the calls it receives and returns an
injectable result. By default it returns believable sample data, so it is usable
with zero setup:

```swift
import TMDbIntelligence
import TMDbIntelligenceTesting

let service = MockNaturalLanguageSearchService()

// Zero-config: returns NaturalLanguageSearchResult.sample.
let result = try await service.search(matching: "movies with Tom Hanks")

// Inject a specific outcome.
service.searchResult = .failure(.outOfScope)

// Assert on what was called.
#expect(service.searchCalls.first?.prompt == "movies with Tom Hanks")
```

### Samples

Every public return type has a `.sample` factory carrying realistic data, so
fixtures read like the real thing rather than placeholders.

## Topics

### Mock Services

- ``MockNaturalLanguageSearchService``
