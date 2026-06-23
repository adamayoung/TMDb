# ``TMDbTesting``

Test doubles and sample data for testing code that depends on TMDb.

## Overview

`TMDbTesting` is a companion library to ``TMDb`` for use in **test targets**. It
provides a spy + stub mock for every TMDb service protocol, plus real-data
sample models, so you can test code that depends on TMDb without hitting the
live API or hand-rolling protocol conformances.

Add it as a dependency of your test target only:

```swift
.testTarget(
    name: "MyAppTests",
    dependencies: ["MyApp", "TMDbTesting"]
)
```

### Mock services

Each service protocol has a matching `Mock<Name>Service`. A mock records the
calls it receives and returns an injectable result. By default a freshly
constructed mock returns believable sample data, so it is usable with zero
setup:

```swift
import TMDb
import TMDbTesting

let movieService = MockMovieService()

// Zero-config: returns Movie.sample.
let movie = try await movieService.details(forMovie: 550)

// Inject a specific outcome.
movieService.detailsResult = .failure(.notFound)

// Assert on what was called.
#expect(movieService.detailsCalls.first?.movieID == 550)
```

Always assert on values you have stubbed rather than relying on the believable
defaults — the defaults exist for ergonomics, not as a contract. Mocks are safe
to share across concurrent calls; their recorded state is guarded by a lock.

### Sample data

Every service return type exposes a `.sample` (and, where it is returned as an
array, a `.samples`) built from realistic TMDb data. These double as the mocks'
default return values and are useful for previews and fixtures:

```swift
let movie = Movie.sample
let genres = [Genre].samples
```

## Topics

### Mock Services

- ``MockAccountService``
- ``MockAuthenticationService``
- ``MockCertificationService``
- ``MockChangesService``
- ``MockCollectionService``
- ``MockCompanyService``
- ``MockConfigurationService``
- ``MockCreditService``
- ``MockDiscoverService``
- ``MockFindService``
- ``MockGenreService``
- ``MockGuestSessionService``
- ``MockKeywordService``
- ``MockListService``
- ``MockMovieService``
- ``MockNaturalLanguageSearchService``
- ``MockNetworkService``
- ``MockPersonService``
- ``MockReviewService``
- ``MockSearchService``
- ``MockTrendingService``
- ``MockTVEpisodeGroupService``
- ``MockTVEpisodeService``
- ``MockTVSeasonService``
- ``MockTVSeriesService``
- ``MockWatchProviderService``
