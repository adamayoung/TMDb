//
//  ShowCastCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ShowCastCreditTests {

    @Test("JSON decoding of ShowCastCredit with movie", .tags(.decoding))
    func decodeReturnsShowCastCreditWithMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCastCredit.self, fromResource: "show-cast-credit-movie"
        )

        guard case .movie(let credit) = result else {
            Issue.record("Expected movie cast credit")
            return
        }

        #expect(credit.id == 109_091)
        #expect(credit.character == "Westray")
    }

    @Test("JSON decoding of ShowCastCredit with TV series", .tags(.decoding))
    func decodeReturnsShowCastCreditWithTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCastCredit.self, fromResource: "show-cast-credit-tv"
        )

        guard case .tvSeries(let credit) = result else {
            Issue.record("Expected TV series cast credit")
            return
        }

        #expect(credit.id == 54)
        #expect(credit.character == "")
    }

    @Test("JSON encoding of movie ShowCastCredit", .tags(.encoding))
    func encodeMovieShowCastCredit() throws {
        let credit = ShowCastCredit.movie(.mock(id: 123, character: "Hero"))

        let data = try JSONEncoder.theMovieDatabase.encode(credit)
        let decoded = try JSONDecoder.theMovieDatabase.decode(ShowCastCredit.self, from: data)

        #expect(decoded.id == 123)
        guard case .movie(let movieCredit) = decoded else {
            Issue.record("Expected movie cast credit")
            return
        }
        #expect(movieCredit.character == "Hero")
    }

    @Test("JSON encoding of TV series ShowCastCredit", .tags(.encoding))
    func encodeTVSeriesShowCastCredit() throws {
        let credit = ShowCastCredit.tvSeries(.mock(id: 456, character: "Villain"))

        let data = try JSONEncoder.theMovieDatabase.encode(credit)
        let decoded = try JSONDecoder.theMovieDatabase.decode(ShowCastCredit.self, from: data)

        #expect(decoded.id == 456)
        guard case .tvSeries(let tvCredit) = decoded else {
            Issue.record("Expected TV series cast credit")
            return
        }
        #expect(tvCredit.character == "Villain")
    }

    @Test("id returns movie credit ID")
    func idReturnsMovieCreditID() {
        let credit = ShowCastCredit.movie(.mock(id: 789))

        #expect(credit.id == 789)
    }

    @Test("id returns TV series credit ID")
    func idReturnsTVSeriesCreditID() {
        let credit = ShowCastCredit.tvSeries(.mock(id: 101))

        #expect(credit.id == 101)
    }

}
