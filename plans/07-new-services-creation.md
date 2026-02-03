# Plan 7: New Services Creation

**Priority:** MEDIUM-LOW
**Impact:** Medium-Low - Specialized features and individual detail endpoints
**Effort:** Low-Medium
**Dependencies:** None

## Overview

Create new services for specialized endpoints: CreditService, ReviewService, TVEpisodeGroupService, and GuestSessionService. These provide individual detail lookups and guest session rating retrieval.

---

## 1. CreditService

### Purpose
Get individual credit details by credit ID (person + media for specific credit).

### Endpoint

**GET /3/credit/{credit_id}** - Get credit details

**Method:** `details(forCredit:)`

### Models Required

#### Credit Model

**File:** `Sources/TMDb/Domain/Models/Credit.swift`

```swift
/// Represents a single credit (cast or crew)
public struct Credit: Codable, Equatable, Hashable, Sendable {
    /// Credit ID
    public let creditID: String

    /// Type of credit
    public let creditType: CreditType

    /// Department (for crew credits)
    public let department: String?

    /// Job title (for crew credits)
    public let job: String?

    /// Media this credit is for
    public let media: Media

    /// Media type
    public let mediaType: MediaType

    /// Person who has this credit
    public let person: Person?
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case creditID = "credit_id"
    case creditType = "credit_type"
    case department
    case job
    case media
    case mediaType = "media_type"
    case person
}
```

#### CreditType Enum

```swift
/// Type of credit
public enum CreditType: String, Codable, Sendable {
    case cast
    case crew
}
```

### Service Protocol

**File:** `Sources/TMDb/Domain/Services/Credits/CreditService.swift`

```swift
/// Provides credit details by credit ID
public protocol CreditService: Sendable {
    /// Returns credit details for a specific credit ID
    ///
    /// - Parameter creditID: The credit identifier
    /// - Returns: Credit details including person and media information
    func details(forCredit creditID: String) async throws -> Credit
}
```

### Implementation

**File:** `Sources/TMDb/Domain/Services/Credits/TMDbCreditService.swift`

```swift
final class TMDbCreditService: CreditService {
    private let apiClient: TMDbAPIClient

    init(apiClient: TMDbAPIClient) {
        self.apiClient = apiClient
    }

    func details(forCredit creditID: String) async throws -> Credit {
        let path = "/credit/\(creditID)"
        let credit: Credit = try await apiClient.get(path: path)
        return credit
    }
}
```

### DocC Documentation

**File:** `Sources/TMDb/TMDb.docc/Extensions/CreditService.md`

```markdown
# ``CreditService``

Get individual credit details.

## Overview

The Credit Service provides access to detailed information about individual credits,
including the person and media associated with a specific credit ID.

## Topics

### Getting Credit Details

- ``CreditService/details(forCredit:)``
```

---

## 2. ReviewService

### Purpose
Get individual review details by review ID.

### Endpoint

**GET /3/review/{review_id}** - Get review details

**Method:** `details(forReview:)`

### Models Required

Reuse existing `Review` model (already exists).

### Service Protocol

**File:** `Sources/TMDb/Domain/Services/Reviews/ReviewService.swift`

```swift
/// Provides review details by review ID
public protocol ReviewService: Sendable {
    /// Returns review details for a specific review ID
    ///
    /// - Parameter reviewID: The review identifier
    /// - Returns: Full review details
    func details(forReview reviewID: String) async throws -> Review
}
```

### Implementation

**File:** `Sources/TMDb/Domain/Services/Reviews/TMDbReviewService.swift`

```swift
final class TMDbReviewService: ReviewService {
    private let apiClient: TMDbAPIClient

    init(apiClient: TMDbAPIClient) {
        self.apiClient = apiClient
    }

    func details(forReview reviewID: String) async throws -> Review {
        let path = "/review/\(reviewID)"
        let review: Review = try await apiClient.get(path: path)
        return review
    }
}
```

### DocC Documentation

**File:** `Sources/TMDb/TMDb.docc/Extensions/ReviewService.md`

```markdown
# ``ReviewService``

Get individual review details.

## Overview

The Review Service provides access to detailed information about individual reviews.
Reviews can be fetched by their unique review ID.

## Topics

### Getting Review Details

- ``ReviewService/details(forReview:)``
```

---

## 3. TVEpisodeGroupService

### Purpose
Get episode group details (alternative episode orderings).

### Endpoint

**GET /3/tv/episode_group/{tv_episode_group_id}** - Get episode group details

**Method:** `details(forEpisodeGroup:)`

### Models Required

#### TVEpisodeGroup Model

**File:** `Sources/TMDb/Domain/Models/TVEpisodeGroup.swift`

```swift
/// Represents a TV episode group (alternative episode ordering)
public struct TVEpisodeGroup: Codable, Equatable, Hashable, Sendable {
    /// Group ID
    public let id: String

    /// Group description
    public let description: String

    /// Number of episodes in group
    public let episodeCount: Int

    /// Number of groups
    public let groupCount: Int

    /// Group name
    public let name: String

    /// Network
    public let network: Network?

    /// Group type (e.g., "Original air date", "DVD", etc.)
    public let type: Int

    /// Groups
    public let groups: [Group]
}
```

**CodingKeys:**
```swift
private enum CodingKeys: String, CodingKey {
    case id
    case description
    case episodeCount = "episode_count"
    case groupCount = "group_count"
    case name
    case network
    case type
    case groups
}
```

#### TVEpisodeGroup.Group Model

```swift
extension TVEpisodeGroup {
    /// A group within an episode group
    public struct Group: Codable, Equatable, Hashable, Sendable {
        /// Group ID
        public let id: String

        /// Group name
        public let name: String

        /// Order in the overall group
        public let order: Int

        /// Episodes in this group
        public let episodes: [TVEpisode]

        /// Locked status
        public let locked: Bool
    }
}
```

### Service Protocol

**File:** `Sources/TMDb/Domain/Services/TVEpisodeGroups/TVEpisodeGroupService.swift`

```swift
/// Provides TV episode group details
public protocol TVEpisodeGroupService: Sendable {
    /// Returns episode group details
    ///
    /// Episode groups provide alternative episode orderings (e.g., DVD order, absolute order).
    ///
    /// - Parameter episodeGroupID: The episode group identifier
    /// - Returns: Episode group with all episodes organized by groups
    func details(forEpisodeGroup episodeGroupID: String) async throws -> TVEpisodeGroup
}
```

### Implementation

**File:** `Sources/TMDb/Domain/Services/TVEpisodeGroups/TMDbTVEpisodeGroupService.swift`

```swift
final class TMDbTVEpisodeGroupService: TVEpisodeGroupService {
    private let apiClient: TMDbAPIClient

    init(apiClient: TMDbAPIClient) {
        self.apiClient = apiClient
    }

    func details(forEpisodeGroup episodeGroupID: String) async throws -> TVEpisodeGroup {
        let path = "/tv/episode_group/\(episodeGroupID)"
        let group: TVEpisodeGroup = try await apiClient.get(path: path)
        return group
    }
}
```

### DocC Documentation

**File:** `Sources/TMDb/TMDb.docc/Extensions/TVEpisodeGroupService.md`

```markdown
# ``TVEpisodeGroupService``

Get TV episode group details.

## Overview

The TV Episode Group Service provides access to alternative episode orderings for TV series.
Episode groups can represent DVD order, absolute order, or other custom orderings.

## Topics

### Getting Episode Group Details

- ``TVEpisodeGroupService/details(forEpisodeGroup:)``
```

---

## 4. GuestSessionService

### Purpose
Get guest session rating lists (movies, TV series, TV episodes).

### Endpoints

1. **GET /3/guest_session/{guest_session_id}/rated/movies** - Guest rated movies
2. **GET /3/guest_session/{guest_session_id}/rated/tv** - Guest rated TV
3. **GET /3/guest_session/{guest_session_id}/rated/tv/episodes** - Guest rated episodes

### Service Protocol

**File:** `Sources/TMDb/Domain/Services/GuestSessions/GuestSessionService.swift`

```swift
/// Provides guest session rating retrieval
public protocol GuestSessionService: Sendable {
    /// Returns movies rated by a guest session
    ///
    /// - Parameters:
    ///   - sortedBy: Sort order for results
    ///   - page: Page number (1-1000)
    ///   - guestSession: Guest session
    /// - Returns: Pageable list of rated movies
    func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        guestSession: GuestSession
    ) async throws -> MoviePageableList

    /// Returns TV series rated by a guest session
    ///
    /// - Parameters:
    ///   - sortedBy: Sort order for results
    ///   - page: Page number (1-1000)
    ///   - guestSession: Guest session
    /// - Returns: Pageable list of rated TV series
    func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        guestSession: GuestSession
    ) async throws -> TVSeriesPageableList

    /// Returns TV episodes rated by a guest session
    ///
    /// - Parameters:
    ///   - sortedBy: Sort order for results
    ///   - page: Page number (1-1000)
    ///   - guestSession: Guest session
    /// - Returns: Pageable list of rated TV episodes
    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        guestSession: GuestSession
    ) async throws -> TVEpisodePageableList
}
```

### Implementation

**File:** `Sources/TMDb/Domain/Services/GuestSessions/TMDbGuestSessionService.swift`

```swift
final class TMDbGuestSessionService: GuestSessionService {
    private let apiClient: TMDbAPIClient

    init(apiClient: TMDbAPIClient) {
        self.apiClient = apiClient
    }

    func ratedMovies(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSession: GuestSession
    ) async throws -> MoviePageableList {
        let path = "/guest_session/\(guestSession.id)/rated/movies"
        let queryItems = buildQueryItems(sortedBy: sortedBy, page: page)
        let list: MoviePageableList = try await apiClient.get(path: path, queryItems: queryItems)
        return list
    }

    func ratedTVSeries(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSession: GuestSession
    ) async throws -> TVSeriesPageableList {
        let path = "/guest_session/\(guestSession.id)/rated/tv"
        let queryItems = buildQueryItems(sortedBy: sortedBy, page: page)
        let list: TVSeriesPageableList = try await apiClient.get(path: path, queryItems: queryItems)
        return list
    }

    func ratedTVEpisodes(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        guestSession: GuestSession
    ) async throws -> TVEpisodePageableList {
        let path = "/guest_session/\(guestSession.id)/rated/tv/episodes"
        let queryItems = buildQueryItems(sortedBy: sortedBy, page: page)
        let list: TVEpisodePageableList = try await apiClient.get(path: path, queryItems: queryItems)
        return list
    }

    private func buildQueryItems(sortedBy: RatedSort?, page: Int?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let sortedBy { queryItems.append(URLQueryItem(name: "sort_by", value: sortedBy.rawValue)) }
        if let page { queryItems.append(URLQueryItem(name: "page", value: "\(page)")) }
        return queryItems
    }
}
```

### DocC Documentation

**File:** `Sources/TMDb/TMDb.docc/Extensions/GuestSessionService.md`

```markdown
# ``GuestSessionService``

Get guest session ratings.

## Overview

The Guest Session Service provides access to content rated by guest sessions.
Guest sessions allow users to rate content without creating an account.

## Topics

### Getting Rated Content

- ``GuestSessionService/ratedMovies(sortedBy:page:guestSession:)``
- ``GuestSessionService/ratedTVSeries(sortedBy:page:guestSession:)``
- ``GuestSessionService/ratedTVEpisodes(sortedBy:page:guestSession:)``
```

---

## Integration Steps

### 1. Register in TMDbFactory

Update `Sources/TMDb/TMDbFactory.swift`:

```swift
static func makeFactory(apiKey: String, httpClient: HTTPClient) -> some TMDbFactory {
    // ... existing services ...

    let creditService = TMDbCreditService(apiClient: apiClient)
    let reviewService = TMDbReviewService(apiClient: apiClient)
    let tvEpisodeGroupService = TMDbTVEpisodeGroupService(apiClient: apiClient)
    let guestSessionService = TMDbGuestSessionService(apiClient: apiClient)

    return Factory(
        // ... existing services ...
        creditService: creditService,
        reviewService: reviewService,
        tvEpisodeGroupService: tvEpisodeGroupService,
        guestSessionService: guestSessionService
    )
}
```

### 2. Expose via TMDbClient

Update `Sources/TMDb/TMDbClient.swift`:

```swift
public final class TMDbClient: Sendable {
    // ... existing properties ...

    /// Credit service
    public let credits: CreditService

    /// Review service
    public let reviews: ReviewService

    /// TV episode group service
    public let tvEpisodeGroups: TVEpisodeGroupService

    /// Guest session service
    public let guestSessions: GuestSessionService

    public init(apiKey: String, httpClient: HTTPClient? = nil) {
        let factory = TMDbFactory.makeFactory(apiKey: apiKey, httpClient: httpClient ?? URLSessionHTTPClientAdapter())

        // ... existing assignments ...
        self.credits = factory.creditService
        self.reviews = factory.reviewService
        self.tvEpisodeGroups = factory.tvEpisodeGroupService
        self.guestSessions = factory.guestSessionService
    }
}
```

### 3. Update DocC TMDbClient Documentation

Update `Sources/TMDb/TMDb.docc/Extensions/TMDbClient.md`:

Add to topics:
```markdown
### Services

- ``TMDbClient/credits``
- ``TMDbClient/reviews``
- ``TMDbClient/tvEpisodeGroups``
- ``TMDbClient/guestSessions``
```

---

## Testing Requirements

### Unit Tests

**Create Test Files:**
- `Tests/TMDbTests/Services/Credits/TMDbCreditServiceTests.swift`
- `Tests/TMDbTests/Services/Reviews/TMDbReviewServiceTests.swift`
- `Tests/TMDbTests/Services/TVEpisodeGroups/TMDbTVEpisodeGroupServiceTests.swift`
- `Tests/TMDbTests/Services/GuestSessions/TMDbGuestSessionServiceTests.swift`

**JSON Fixtures:**
- `Tests/TMDbTests/Resources/json/credit.json`
- `Tests/TMDbTests/Resources/json/review.json`
- `Tests/TMDbTests/Resources/json/tv-episode-group.json`
- `Tests/TMDbTests/Resources/json/guest-session-rated-movies.json`
- `Tests/TMDbTests/Resources/json/guest-session-rated-tv.json`
- `Tests/TMDbTests/Resources/json/guest-session-rated-episodes.json`

### Integration Tests

**Create Integration Test Files:**
- `Tests/TMDbIntegrationTests/CreditIntegrationTests.swift`
- `Tests/TMDbIntegrationTests/ReviewIntegrationTests.swift`
- `Tests/TMDbIntegrationTests/TVEpisodeGroupIntegrationTests.swift`
- `Tests/TMDbIntegrationTests/GuestSessionIntegrationTests.swift`

---

## Documentation Updates

Add all new services and models to `Sources/TMDb/TMDb.docc/TMDb.md`:

```markdown
### Services

- ``CreditService``
- ``ReviewService``
- ``TVEpisodeGroupService``
- ``GuestSessionService``

### Models

- ``Credit``
- ``CreditType``
- ``TVEpisodeGroup``
```

---

## API Endpoints Reference

```
GET /3/credit/{credit_id}
GET /3/review/{review_id}
GET /3/tv/episode_group/{tv_episode_group_id}
GET /3/guest_session/{guest_session_id}/rated/movies?sort_by={sort}&page={page}
GET /3/guest_session/{guest_session_id}/rated/tv?sort_by={sort}&page={page}
GET /3/guest_session/{guest_session_id}/rated/tv/episodes?sort_by={sort}&page={page}
```

---

## Verification Checklist

Before considering complete:
- [ ] All 4 new services created with protocols and implementations
- [ ] All models created with full test coverage
- [ ] Services registered in TMDbFactory
- [ ] Services exposed via TMDbClient
- [ ] Unit tests passing with JSON fixtures
- [ ] Integration tests passing against live API
- [ ] DocC documentation complete for all services
- [ ] Code formatted (`make format`)
- [ ] Linting passing (`make lint`)
- [ ] All tests passing (`make test && make integration-test`)

---

## Impact Assessment

**User-Facing Benefits:**
- ✅ Individual credit/review lookups by ID
- ✅ Episode group details for alternative orderings
- ✅ Guest session rating retrieval

**API Coverage Improvement:**
- Adds 4 new services
- Implements 6 previously missing endpoints

---

## Notes

- These are specialized/niche endpoints with lower usage
- Credit IDs come from credits endpoints
- Review IDs come from review list endpoints
- Episode group IDs come from TV series episode_groups endpoint
- Guest sessions don't require authentication
