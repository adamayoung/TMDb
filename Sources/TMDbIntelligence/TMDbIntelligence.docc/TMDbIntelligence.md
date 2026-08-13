# ``TMDbIntelligence``

On-device natural-language search and Foundation Models tools for TMDb.

## Overview

`TMDbIntelligence` is a companion library to `TMDb` that adds **on-device
intelligence** on top of the core client: interpret a free-text prompt like
`"movies with Tom Hanks"` and run it against TMDb, or hand a
`LanguageModelSession` a ready-made toolbox so it can answer movie questions
itself.

It is an **opt-in** product. The core `TMDb` library stays free of
Apple-only API, so adding intelligence is an explicit dependency and an
explicit `import`:

```swift
.product(name: "TMDbIntelligence", package: "TMDb")
```

```swift
import TMDb
import TMDbIntelligence

let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")
let results = try await tmdbClient.naturalLanguageSearch.search(matching: "movies with Tom Hanks")
```

- Important: This is an **Apple-platforms** library. Its features are built on
  Apple's Natural Language and Foundation Models frameworks. The module still
  compiles on Linux and Windows — its value types exist so cross-platform code
  can reference them — but the `TMDbClient` accessors that construct a working
  service are unavailable there, so there is nothing to call. Use it on iOS,
  macOS, watchOS, tvOS, or visionOS.

### Natural-language search

``TMDb/TMDbClient/naturalLanguageSearch`` interprets a prompt on device and executes
the resulting plan against TMDb. Interpretation is deterministic — a rule-based
intent classifier plus `NLTagger` person-name extraction. On devices with Apple
Intelligence, Foundation Models additionally handles fuzzier, compositional
prompts; where neither is available the prompt degrades to a plain
multi-search.

The Foundation Models tier is available on iOS, macOS and visionOS only. Apple
ships no on-device system language model for tvOS or watchOS, so interpretation
there is always deterministic — the search itself works on all five platforms.

Check ``NaturalLanguageSearchService/availability`` before searching to find
out which level of interpretation the current device offers.

### Language model tools

``TMDbToolbox`` wraps TMDb as a set of Foundation Models `Tool`s, so a
`LanguageModelSession` can search titles, fetch details and credits, look up a
person's filmography, check what is trending, and find watch providers — each
tool returning compact text the model can chain.

```swift
let session = LanguageModelSession(tools: tmdbClient.languageModelTools)
```

See <doc:/UsingLanguageModelTools> for the full walkthrough.

## Topics

### Essentials

- <doc:/UsingLanguageModelTools>

### Natural-Language Search

- ``TMDb/TMDbClient/naturalLanguageSearch``
- ``NaturalLanguageSearchService``
- ``SearchPlan``
- ``NaturalLanguageSearchResult``
- ``SearchDegradation``
- ``NaturalLanguageSearchAvailability``
- ``NaturalLanguageSearchError``

### Language Model Tools

- ``TMDbToolbox``
- ``TMDb/TMDbClient/languageModelTools``

### Individual Language Model Tools

- ``TMDb/TMDbClient/searchTool``
- ``TMDb/TMDbClient/movieDetailsTool``
- ``TMDb/TMDbClient/movieCreditsTool``
- ``TMDb/TMDbClient/tvSeriesDetailsTool``
- ``TMDb/TMDbClient/personFilmographyTool``
- ``TMDb/TMDbClient/trendingTool``
- ``TMDb/TMDbClient/watchProvidersTool``
- ``TMDb/TMDbClient/discoverMoviesTool``
