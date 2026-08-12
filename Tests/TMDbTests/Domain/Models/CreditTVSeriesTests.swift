//
//  CreditTVSeriesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .credit))
struct CreditTVSeriesTests {

    @Test("JSON decoding of CreditTVSeries", .tags(.decoding))
    func decodeCreditTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit"
        )

        guard case .tvSeries(let tvSeries) = result.media else {
            Issue.record("Expected TV series media type")
            return
        }

        #expect(tvSeries == breakingBad)
    }

    @Test(
        "JSON decoding of CreditTVSeries with an empty first air date returns nil first air date",
        .tags(.decoding)
    )
    func decodeCreditTVSeriesWithEmptyFirstAirDateReturnsNilFirstAirDate() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit-tv-blank-first-air-date"
        )

        guard case .tvSeries(let tvSeries) = result.media else {
            Issue.record("Expected TV series media type")
            return
        }

        #expect(tvSeries.id == 302_069)
        #expect(tvSeries.name == "Untitled Peaky Blinders Sequel")
        #expect(tvSeries.firstAirDate == nil)
        #expect(tvSeries.character == nil)
    }

    @Test(
        "JSON decoding of CreditTVSeries without optional properties returns nil properties",
        .tags(.decoding)
    )
    func decodeCreditTVSeriesWithoutOptionalPropertiesReturnsNilProperties() throws {
        let data = Data(#"{"media_type": "tv", "id": 1396}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(
            CreditMedia.self,
            from: data
        )

        guard case .tvSeries(let tvSeries) = result else {
            Issue.record("Expected TV series media type")
            return
        }

        #expect(tvSeries.id == 1396)
        #expect(tvSeries.name == nil)
        #expect(tvSeries.originalName == nil)
        #expect(tvSeries.overview == nil)
        #expect(tvSeries.posterPath == nil)
        #expect(tvSeries.backdropPath == nil)
        #expect(tvSeries.popularity == nil)
        #expect(tvSeries.firstAirDate == nil)
        #expect(tvSeries.voteAverage == nil)
        #expect(tvSeries.voteCount == nil)
        #expect(tvSeries.character == nil)
    }

}

extension CreditTVSeriesTests {

    private var breakingBad: CreditTVSeries {
        .init(
            id: 1396,
            name: "Breaking Bad",
            originalName: "Breaking Bad",
            overview: "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer.",
            posterPath: URL(string: "/ztkUQFLlC19CCMYHW9o1zWhJRNq.jpg"),
            backdropPath: URL(string: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg"),
            popularity: 108.6266,
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2008-01-20"),
            voteAverage: 8.937,
            voteCount: 17020,
            character: "Walter White"
        )
    }

}
