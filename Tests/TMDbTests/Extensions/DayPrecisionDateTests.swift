//
//  DayPrecisionDateTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Day-precision dates (`"1999-10-15"`) are interpreted at **GMT**, in both
/// directions, so the same wire value is the same `Date` instant on every
/// machine and a `Date` used as a query filter reaches TMDb as the calendar
/// day the caller meant.
///
/// **These assertions are only meaningful because CI runs the unit suites
/// under a `TZ` matrix.** Every expectation below reads `== <GMT value>`,
/// which passes trivially on a UTC runner whether or not the production code
/// pins a time zone. `.github/workflows/ci.yml`'s `unit-test-timezones` job
/// runs them under `America/Los_Angeles` (−8) and `Pacific/Auckland` (+13),
/// and that is what makes them a test rather than a tautology. Remove that
/// job and this file silently stops proving anything.
///
@Suite("Day-precision dates are GMT-pinned", .tags(.formatting))
struct DayPrecisionDateTests {

    /// 1999-10-15T00:00:00Z — Fight Club's release date.
    private static let releaseDayInstant = Date(timeIntervalSince1970: 939_945_600)
    /// 2024-01-01T00:00:00Z.
    private static let newYear2024 = Date(timeIntervalSince1970: 1_704_067_200)
    /// 2024-12-31T00:00:00Z.
    private static let newYearEve2024 = Date(timeIntervalSince1970: 1_735_603_200)

    // MARK: - Inbound

    @Test("day-precision date decodes to GMT midnight", .tags(.decoding))
    func dayPrecisionDateDecodesToGMTMidnight() throws {
        let data = Data(#"{"release_date":"1999-10-15"}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(DayPrecisionPayload.self, from: data)

        #expect(result.releaseDate == Self.releaseDayInstant)
    }

    @Test("v4 decoder decodes a day-precision date to the same GMT instant as v3", .tags(.decoding))
    func v4DecoderDecodesDayPrecisionDateToSameGMTInstantAsV3() throws {
        let data = Data(#"{"release_date":"1999-10-15"}"#.utf8)

        let v3Decoded = try JSONDecoder.theMovieDatabase.decode(DayPrecisionPayload.self, from: data)
        let v4Decoded = try JSONDecoder.theMovieDatabaseV4.decode(DayPrecisionPayload.self, from: data)

        #expect(v4Decoded.releaseDate == Self.releaseDayInstant)
        #expect(v4Decoded.releaseDate == v3Decoded.releaseDate)
    }

    // MARK: - Outbound

    @Test("person changes request sends the GMT calendar day", .tags(.requests))
    func personChangesRequestSendsGMTCalendarDay() {
        let request = PersonChangesRequest(id: 500, startDate: Self.newYear2024, endDate: Self.newYearEve2024)

        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-12-31")
    }

    @Test("discover movies request sends the GMT calendar day", .tags(.requests))
    func discoverMoviesRequestSendsGMTCalendarDay() {
        let filter = DiscoverMovieFilter(
            releaseDateMin: Self.newYear2024,
            releaseDateMax: Self.newYearEve2024
        )

        let request = DiscoverMoviesRequest(filter: filter)

        #expect(request.queryItems["release_date.gte"] == "2024-01-01")
        #expect(request.queryItems["release_date.lte"] == "2024-12-31")
    }

    // MARK: - Round trip

    @Test("a day-precision date survives an encode/decode round trip", .tags(.decoding))
    func dayPrecisionDateSurvivesEncodeDecodeRoundTrip() throws {
        let payload = DayPrecisionPayload(releaseDate: Self.releaseDayInstant)

        let encoded = try JSONEncoder.theMovieDatabase.encode(payload)
        let json = try #require(String(data: encoded, encoding: .utf8))
        let decoded = try JSONDecoder.theMovieDatabase.decode(DayPrecisionPayload.self, from: encoded)

        #expect(json.contains(#""1999-10-15""#))
        #expect(decoded.releaseDate == Self.releaseDayInstant)
    }

    // MARK: - Model

    @Test("MediaListItem decodes a day-precision date to GMT midnight", .tags(.decoding))
    func mediaListItemDecodesDayPrecisionDateToGMTMidnight() throws {
        let json = """
        {
          "id": 1,
          "name": "A Series",
          "original_name": "A Series",
          "overview": "An overview.",
          "media_type": "tv",
          "original_language": "en",
          "first_air_date": "2025-10-26"
        }
        """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaListItem.self, from: data)

        #expect(result.releaseDate == Date(timeIntervalSince1970: 1_761_436_800))
    }

}

private struct DayPrecisionPayload: Codable, Equatable {

    let releaseDate: Date?

}
