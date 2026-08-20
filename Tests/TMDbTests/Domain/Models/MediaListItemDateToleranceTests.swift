//
//  MediaListItemDateToleranceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Characterisation of the accepted/rejected boundary for `MediaListItem`'s
/// day-precision date.
///
/// `MediaListItem` decodes its date with `try?`, so *any* parse failure becomes
/// `nil` rather than an error. A change of parsing engine therefore cannot be
/// caught by the happy-path tests — it would show up only as a release date
/// silently becoming `nil`, or silently becoming a plausible wrong value, in a
/// consumer's app.
///
/// These cases pin the boundary so such a change is a measured decision rather
/// than an assumed no-op. They are why `MediaListItem` still carries its own
/// `.iso8601` strategy instead of sharing
/// `JSONDecoder.theMovieDatabaseDateStrategy`: the shared strategy is lenient
/// and rolls out-of-range components over (`"2025-13-45"` parses as 2026-02-14),
/// where `.iso8601` rejects them.
///
@Suite("MediaListItem date tolerance", .tags(.models))
struct MediaListItemDateToleranceTests {

    @Test(
        "an unparseable release_date decodes as nil",
        .tags(.decoding),
        arguments: ["0000-00-00", "2025-13-45", "1999", "not-a-date", "2025/10/26", ""]
    )
    func unparseableReleaseDateDecodesAsNil(dateString: String) throws {
        let data = Data(Self.json(releaseDate: dateString).utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.releaseDate == nil)
    }

    /// The permissive half, and the half that actually constrains the parser
    /// choice: a trailing time component is **accepted**. That matters in
    /// production — `/movie/{id}/release_dates` sends
    /// `"1999-10-15T00:00:00.000Z"` rather than a bare day, so a stricter
    /// parser would turn a real release date into `nil` behind the `try?`.
    @Test(
        "an accepted release_date form decodes to its documented instant",
        .tags(.decoding),
        arguments: [
            ("2025-10-26", 1_761_436_800.0),
            ("2025-10-26T00:00:00Z", 1_761_436_800.0),
            ("99-10-15", -59_018_371_200.0)
        ]
    )
    func acceptedReleaseDateFormDecodesToDocumentedInstant(
        dateString: String,
        expectedTimeIntervalSince1970: Double
    ) throws {
        let data = Data(Self.json(releaseDate: dateString).utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        let releaseDate = try #require(result.releaseDate)
        #expect(releaseDate == Date(timeIntervalSince1970: expectedTimeIntervalSince1970))
    }

    private static func json(releaseDate: String) -> String {
        """
        {
          "id": 5,
          "title": "A Movie",
          "original_title": "A Movie",
          "overview": "An overview.",
          "media_type": "movie",
          "original_language": "en",
          "release_date": "\(releaseDate)"
        }
        """
    }

}
