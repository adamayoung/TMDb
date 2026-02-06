//
//  TrendingItemTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TrendingItemTests {

    @Test("id when movie returns movieID")
    func idWhenMovieReturnsMovieID() {
        let item = TrendingItem.movie(.theFirstOmen)

        #expect(item.id == 437_342)
    }

    @Test("id when TV series returns tvSeriesID")
    func idWhenTVSeriesReturnsTVSeriesID() {
        let item = TrendingItem.tvSeries(.bigBrother)

        #expect(item.id == 11366)
    }

    @Test("id when person returns personID")
    func idWhenPersonReturnsPersonID() {
        let item = TrendingItem.person(.bradPitt)

        #expect(item.id == 287)
    }

    @Test("JSON decoding of TrendingItem", .tags(.decoding))
    func decodeReturnsTrendingItems() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TrendingPageableList.self, fromResource: "trending-all"
        )

        #expect(result.results.count == 3)
    }

    @Test("JSON decoding of TrendingItem movie", .tags(.decoding))
    func decodeReturnsTrendingMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TrendingPageableList.self, fromResource: "trending-all"
        )

        guard case .movie(let movie) = result.results[0] else {
            Issue.record("Expected movie trending item")
            return
        }

        #expect(movie.id == 1_368_166)
        #expect(movie.title == "The Housemaid")
    }

    @Test("JSON decoding of TrendingItem TV series", .tags(.decoding))
    func decodeReturnsTrendingTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TrendingPageableList.self, fromResource: "trending-all"
        )

        guard case .tvSeries(let tvSeries) = result.results[1] else {
            Issue.record("Expected TV series trending item")
            return
        }

        #expect(tvSeries.id == 106_379)
        #expect(tvSeries.name == "Fallout")
    }

    @Test("JSON decoding of TrendingItem person", .tags(.decoding))
    func decodeReturnsTrendingPerson() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TrendingPageableList.self, fromResource: "trending-all"
        )

        guard case .person(let person) = result.results[2] else {
            Issue.record("Expected person trending item")
            return
        }

        #expect(person.id == 12345)
        #expect(person.name == "John Doe")
    }

    @Test(
        "JSON encoding and decoding of TrendingItem round trips correctly",
        .tags(.encoding, .decoding)
    )
    func encodeDecodeRoundTrip() throws {
        let trendingItems: [TrendingItem] = [
            .movie(.theFirstOmen),
            .tvSeries(.bigBrother),
            .person(.bradPitt)
        ]

        for item in trendingItems {
            let data = try JSONEncoder.theMovieDatabase.encode(item)
            let decoded = try JSONDecoder.theMovieDatabase.decode(
                TrendingItem.self, from: data
            )
            #expect(decoded == item)
        }
    }

    @Test("JSON encoding of movie trending item", .tags(.encoding))
    func encodeMovieTrendingItem() throws {
        let movie = MovieListItem.theFirstOmen
        let item = TrendingItem.movie(movie)

        let data = try JSONEncoder.theMovieDatabase.encode(item)
        let decodedMovie = try JSONDecoder.theMovieDatabase.decode(
            MovieListItem.self, from: data
        )

        #expect(decodedMovie == movie)
    }

    @Test("JSON encoding of TV series trending item", .tags(.encoding))
    func encodeTVSeriesTrendingItem() throws {
        let tvSeries = TVSeriesListItem.bigBrother
        let item = TrendingItem.tvSeries(tvSeries)

        let data = try JSONEncoder.theMovieDatabase.encode(item)
        let decodedTVSeries = try JSONDecoder.theMovieDatabase.decode(
            TVSeriesListItem.self, from: data
        )

        #expect(decodedTVSeries == tvSeries)
    }

    @Test("JSON encoding of person trending item", .tags(.encoding))
    func encodePersonTrendingItem() throws {
        let person = PersonListItem.bradPitt
        let item = TrendingItem.person(person)

        let data = try JSONEncoder.theMovieDatabase.encode(item)
        let decodedPerson = try JSONDecoder.theMovieDatabase.decode(
            PersonListItem.self, from: data
        )

        #expect(decodedPerson == person)
    }

}
