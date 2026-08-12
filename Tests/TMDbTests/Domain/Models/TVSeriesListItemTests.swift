//
//  TVSeriesListItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeriesListItemTests {

    @Test("JSON decoding of TVSeriesListItem", .tags(.decoding))
    func decodeReturnsTVSeriesListItem() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesListItem.self, fromResource: "tv-series-list-item"
        )

        #expect(result == tvSeries)
    }

    @Test(
        "JSON decoding of TVSeriesListItem with missing genreIds defaults to empty",
        .tags(.decoding)
    )
    func decodeWhenGenreIDsMissingReturnsEmptyGenreIDs() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesListItem.self, fromResource: "tv-series-list-item-no-genre-ids"
        )

        #expect(result.id == 11366)
        #expect(result.genreIDs == [])
    }

    /// `origin_country` was present on all 1,046 rows sampled across search,
    /// discover, trending, similar and recommendations, so this fallback is
    /// defence in depth rather than a fix for an observed failure — but it is
    /// reachable behaviour, so it gets a test like every other decoder branch.
    @Test(
        "JSON decoding of TVSeriesListItem with missing origin_country",
        .tags(.decoding)
    )
    func decodeWhenOriginCountriesMissingReturnsEmptyOriginCountries() throws {
        let json = """
        {
          "id": 1,
          "name": "A TV Series",
          "original_name": "A TV Series",
          "original_language": "en",
          "overview": "An overview."
        }
        """

        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesListItem.self, from: Data(json.utf8)
        )

        #expect(result.id == 1)
        #expect(result.originCountries == [])
    }

}

extension TVSeriesListItemTests {

    private var tvSeries: TVSeriesListItem {
        TVSeriesListItem(
            id: 11366,
            name: "Big Brother",
            originalName: "Big Brother",
            originalLanguage: "en",
            overview:
            // swiftlint:disable:next line_length
            "A British reality television game show in which a number of contestants live in an isolated house for several weeks, trying to avoid being evicted by the public with the aim of winning a large cash prize at the end of the run.",
            genreIDs: [10764],
            firstAirDate: DateFormatter.theMovieDatabase.date(from: "2000-07-18"),
            originCountries: ["GB"],
            posterPath: URL(string: "/p7lsmCU5ZqaMGKZAuZMkFc02X8o.jpg"),
            backdropPath: URL(string: "/3SWOj8ydFrxiuZdLg63fDAt4jYR.jpg"),
            popularity: 5434.15,
            voteAverage: 3.833,
            voteCount: 48,
            isAdultOnly: false
        )
    }

}
