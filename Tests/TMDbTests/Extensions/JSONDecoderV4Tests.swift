//
//  JSONDecoderV4Tests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// The v4 decoder has to handle **both** TMDb date shapes, because one v4
/// response can contain each: account-list summaries carry
/// `"2026-08-06 23:26:00 UTC"` while list items carry `"1999-10-15"`. Neither
/// existing decoder parses both.
///
@Suite(.tags(.networking))
struct JSONDecoderV4Tests {

    private struct DayPrecision: Decodable, Equatable {
        let releaseDate: Date
    }

    private struct Timestamp: Decodable, Equatable {
        let createdAt: Date
    }

    @Test("decodes the account-list timestamp form, in UTC")
    func decodesTimestampForm() throws {
        let data = Data(#"{"created_at": "2026-08-06 23:26:00 UTC"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(Timestamp.self, from: data)

        var components = DateComponents()
        components.year = 2026
        components.month = 8
        components.day = 6
        components.hour = 23
        components.minute = 26
        components.second = 0
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let expected = try #require(calendar.date(from: components))
        #expect(result.createdAt == expected)
    }

    @Test("decodes the day-precision form")
    func decodesDayPrecisionForm() throws {
        let data = Data(#"{"release_date": "1999-10-15"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(DayPrecision.self, from: data)

        #expect(result.releaseDate != Date(timeIntervalSince1970: 0))
    }

    @Test("a day-precision date decodes identically to the v3 decoder")
    func dayPrecisionMatchesV3Decoder() throws {
        // The two decoders must agree, or the same `releaseDate` would land on a
        // different instant depending on which API version fetched it. That
        // means reusing v3's time zone (the current one), not GMT.
        let data = Data(#"{"release_date": "1999-10-15"}"#.utf8)

        let v4Decoded = try JSONDecoder.theMovieDatabaseV4.decode(DayPrecision.self, from: data)
        let v3Decoded = try JSONDecoder.theMovieDatabase.decode(DayPrecision.self, from: data)

        #expect(v4Decoded.releaseDate == v3Decoded.releaseDate)
    }

    @Test("both date forms decode from one response")
    func decodesBothFormsFromOneResponse() throws {
        struct Mixed: Decodable {
            let createdAt: Date
            let releaseDate: Date
        }
        let data = Data(#"""
        {"created_at": "2026-08-06 23:26:00 UTC", "release_date": "1999-10-15"}
        """#.utf8)

        let result = try JSONDecoder.theMovieDatabaseV4.decode(Mixed.self, from: data)

        #expect(result.createdAt > result.releaseDate)
    }

    @Test("an unparseable date throws rather than silently defaulting")
    func unparseableDateThrows() throws {
        let data = Data(#"{"release_date": "not-a-date"}"#.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder.theMovieDatabaseV4.decode(DayPrecision.self, from: data)
        }
    }

}
