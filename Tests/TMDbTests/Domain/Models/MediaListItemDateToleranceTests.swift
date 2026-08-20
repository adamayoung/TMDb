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
    /// choice.
    ///
    /// A trailing time component is accepted, and the time is **discarded** —
    /// a nonzero time still lands on GMT midnight of the same day, which is
    /// what `releaseDate`'s DocC promises. This boundary is characterised
    /// defensively rather than in response to a known payload: `MediaListItem`
    /// decodes v3 `/list/{id}` rows, which send a bare day. (The full-timestamp
    /// form does exist elsewhere in the API — `/movie/{id}/release_dates` —
    /// but that decodes into `ReleaseDate`, not this type.)
    @Test(
        "an accepted release_date form decodes to its documented instant",
        .tags(.decoding),
        arguments: [
            ("2025-10-26", 1_761_436_800.0),
            ("2025-10-26T00:00:00Z", 1_761_436_800.0),
            ("2025-10-26T14:30:00Z", 1_761_436_800.0),
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
