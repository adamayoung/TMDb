---
name: document-swift
description: Write and maintain high-quality Swift DocC documentation for the TMDb package, following its established `///` conventions. Use when adding or changing any public declaration (protocol, class, struct, enum, actor, model, property, initializer, method, typealias) and when keeping the DocC catalog in sync. This is the single source of truth for the project's documentation style — applied inline as you write, and followed by the `documentation-writer` agent for bulk sweeps.
---

# Document Swift (DocC conventions)

The canonical guide for documenting public API in the TMDb Swift package. Apply
these conventions **inline, in the same step you write the declaration** — a
public symbol without a `///` comment is not finished (`CLAUDE.md` requires it,
and `make build-docs` runs warnings-as-errors, so a miss breaks the build). For
documenting many files at once, the `documentation-writer` agent follows these
same rules in an isolated context.

## Scope

- Document **only** `public` declarations — skip `internal`, `private`,
  `fileprivate`, `package`.
- Document **every** public declaration — no "self-explanatory" exceptions:
  protocols, classes, structs, enums (and cases where meaning isn't obvious),
  actors, typealiases, models, stored/computed properties, initializers, methods,
  subscripts. Custom `init(from:)` / `encode(to:)` in a `public extension` need
  comments too (a common miss).
- Use `///` style — **never** `/** */`.
- **100-character** line length; wrap continuation lines indented to align with
  the text above.

## Summary patterns

The first `///` line after the opening blank `///` is the summary. Match the
project's house style by declaration kind:

- **Method** — verb phrase: "Returns the primary information about a movie." (not
  "Gets a movie.")
- **Property** — noun phrase: "Movie identifier." (not "The ID of the movie.")
- **Type (struct/class)** — "A model representing a [noun]."
- **Protocol** — "Provides an interface for [verb]-ing [noun] from TMDb."
- **Enum** — "A model representing a [noun]."; cases use concise noun
  phrases/adjectives.
- **Initializer** — "Creates a [type description] object."

Be concise. Extra detail goes in later paragraphs only when it adds something the
signature doesn't.

## Structure of a doc comment

Opening `///`, summary, blank `///`, then sections in this order, each separated
by a blank `///` line: **API link → Precondition → Parameters → Throws →
Returns**. No trailing whitespace on blank `///` lines.

- **TMDb API link** — every **service protocol method** includes, right after the
  summary:
  `/// [TMDb API - <Category>: <Endpoint>](https://developer.themoviedb.org/reference/<slug>)`
- **Parameters** — `- Parameter name:` (singular) for exactly one parameter;
  `- Parameters:` with an indented list for two or more.
- **Precondition** — methods with a `page` parameter add a
  `/// - Precondition:` line — e.g. `page` can be between `1` and `1000`.
- **Throws** — service methods use `/// - Throws: TMDb error ``TMDbError``.`; for
  `Decodable` inits, list the specific `DecodingError` cases.
- **Returns** — describe what comes back, e.g. "Matching review."

### Standard parameter descriptions (reuse verbatim)

- `language`: "ISO 639-1 language code to display results in. Defaults to the
  client's configured default language."
- `country`: "ISO 3166-1 country code."
- `page`: "The page of results to return."
- `id` parameters: "The identifier of the [entity]."
- `session`: "The user's TMDb session."

## Cross-references

- Types: double backticks — `` ``TMDbError`` ``.
- Articles/guides: `<doc:/TMDb/ArticleName>`.
- **Image paths**: any `URL?` property representing an image path — `posterPath`,
  `backdropPath`, `profilePath`, `logoPath`, `stillPath` — must add, on its own
  paragraph: "To generate a full URL see <doc:/TMDb/GeneratingImageURLs>."

## Canonical examples

Service method, multiple parameters (note Precondition + plural `Parameters`):

```swift
///
/// Returns the user reviews for a movie.
///
/// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
///
/// - Precondition: `page` can be between `1` and `1000`.
///
/// - Parameters:
///    - movieID: The identifier of the movie.
///    - page: The page of results to return.
///    - language: ISO 639-1 language code to display results in.
///     Defaults to the client's configured default language.
///
/// - Throws: TMDb error ``TMDbError``.
///
/// - Returns: Reviews for the matching movie as a pageable list.
///
func reviews(
    forMovie movieID: Movie.ID,
    page: Int?,
    language: String?
) async throws -> ReviewPageableList
```

Service method, single parameter (singular `Parameter`):

```swift
///
/// Returns a review's details.
///
/// [TMDb API - Reviews: Details](https://developer.themoviedb.org/reference/review-details)
///
/// - Parameter id: The identifier of the review.
///
/// - Throws: TMDb error ``TMDbError``.
///
/// - Returns: Matching review.
///
func details(forReview id: Review.ID) async throws -> Review
```

Model struct with an image path and a matching initializer:

```swift
///
/// A model representing a movie.
///
public struct MovieListItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie identifier.
    ///
    public let id: Int

    ///
    /// Movie poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Creates a movie list item object.
    ///
    /// - Parameters:
    ///    - id: Movie identifier.
    ///    - posterPath: Movie poster path.
    ///
    public init(id: Int, posterPath: URL? = nil)
}
```

Initializer parameter descriptions must stay consistent with the corresponding
property documentation.

## Keep the DocC catalog in sync

When public API changes, update `Sources/TMDb/TMDb.docc/` so `make build-docs`
(warnings-as-errors) stays green:

- **New service** → create `Extensions/<ServiceName>Service.md`; add the service
  and its return types to `TMDb.md`; add the property to `TMDbClient.md`.
- **New method on an existing service** → add a reference under the right topic
  heading in the service's extension file, double-backtick with labels:
  `` ``reviews(forMovie:page:language:)`` ``.
- **New public model/type** → add to the appropriate topic section in `TMDb.md`.
- **Renamed/removed API** → update every affected catalog file.

Extension file shape:

```markdown
# ``MovieService``

## Topics

### Reviews

- ``reviews(forMovie:page:language:)``
```

## Keep the README API overview in sync

`README.md` carries a human-facing overview that drifts out of date as the API
grows — update it in the same change, then run `make lint-markdown`:

- **Available Services table** (`## Available Services`) — one row per service,
  `| **serviceName** | capability, capability, … |`.
  - *New service* → add a row, and bump the service count in the
    `**Comprehensive API Coverage**` feature bullet (currently "26 specialized
    services") so the number stays accurate.
  - *New method/capability on an existing service* → extend that service's row
    description if it adds a notable capability (e.g. add "watch providers" to the
    **movies** row). A new endpoint that's just a variant of an existing one does
    not always need a new word — judge whether a user scanning the table would
    miss it.
- **Features list** (`## Features`) → add or amend a bullet when the change
  introduces a headline, user-visible capability (a new search mode, a new
  formatting conformance, etc.), not for routine endpoint additions.
- **Code examples** (`## Setup`, `## Common Use Cases`) → if the change alters a
  usage pattern shown in an example, update the example; these aren't compiled, so
  verify types, property names, and `try`/`await` by hand.
- **Requirements / Installation** → only if platform support or
  `swift-tools-version` changed.

Rule of thumb: the README is the at-a-glance map of the API — if a user reading
only the Features list and the service table would now have a wrong or incomplete
picture, fix it here. Skip churn for purely internal changes.

## What NOT to do

- Don't repeat what the signature already says, or use vague filler ("does
  something", "handles stuff").
- Don't leave placeholders (`/// ?`, `Array of...`) — write complete descriptions.
- Don't copy-paste carelessly: catch "movie" left in a `Person` doc, or
  `Movie.ID` where `Person.ID` is meant.
- Don't reference SwiftUI/UIKit — this is a pure API-client library.
- Don't add `@available` unless it matches the enclosing type's declaration.

## Verify before finishing

1. Every public declaration in the change has a `///` comment.
2. Summary style matches the declaration kind; structure is summary → blank →
   sections, no trailing whitespace.
3. Service methods carry the `[TMDb API - …]` link.
4. Singular vs plural `Parameter(s)` is correct; order is Parameters → Throws →
   Returns.
5. Lines ≤ 100 chars; image-path properties cross-reference the image-URL guide.
6. Init parameter docs match property docs.
7. DocC catalog (extension files, `TMDb.md`, `TMDbClient.md`) reflects the
   current public API.
8. `README.md` overview is in sync — the **Available Services** table (row +
   capability words), the service **count** in the Features bullet, the
   **Features** list for any headline capability, and any affected code examples.
9. Run `make build-docs` to confirm docs compile with no warnings, and
   `make lint-markdown` if `README.md` (or any `.md`) changed.

For Apple API specifics (concurrency safety, availability, behaviour), look it up
with the sosumi MCP tools rather than guessing. For documenting `async`/`actor`/
`Sendable` API, the `swift-concurrency` skill has the concurrency vocabulary.
