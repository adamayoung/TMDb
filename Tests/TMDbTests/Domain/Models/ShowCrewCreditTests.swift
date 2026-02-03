//
//  ShowCrewCreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ShowCrewCreditTests {

    @Test("JSON decoding of ShowCrewCredit with movie", .tags(.decoding))
    func decodeReturnsShowCrewCreditWithMovie() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCrewCredit.self, fromResource: "show-crew-credit-movie"
        )

        guard case .movie(let credit) = result else {
            Issue.record("Expected movie crew credit")
            return
        }

        #expect(credit.id == 174_349)
        #expect(credit.job == "Executive Producer")
        #expect(credit.department == "Production")
    }

    @Test("JSON decoding of ShowCrewCredit with TV series", .tags(.decoding))
    func decodeReturnsShowCrewCreditWithTVSeries() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCrewCredit.self, fromResource: "show-crew-credit-tv"
        )

        guard case .tvSeries(let credit) = result else {
            Issue.record("Expected TV series crew credit")
            return
        }

        #expect(credit.id == 69061)
        #expect(credit.job == "Executive Producer")
        #expect(credit.department == "Production")
    }

    @Test("JSON encoding of movie ShowCrewCredit", .tags(.encoding))
    func encodeMovieShowCrewCredit() throws {
        let credit = ShowCrewCredit.movie(.mock(id: 123, job: "Director", department: "Directing"))

        let data = try JSONEncoder.theMovieDatabase.encode(credit)
        let decoded = try JSONDecoder.theMovieDatabase.decode(ShowCrewCredit.self, from: data)

        #expect(decoded.id == 123)
        guard case .movie(let movieCredit) = decoded else {
            Issue.record("Expected movie crew credit")
            return
        }
        #expect(movieCredit.job == "Director")
        #expect(movieCredit.department == "Directing")
    }

    @Test("JSON encoding of TV series ShowCrewCredit", .tags(.encoding))
    func encodeTVSeriesShowCrewCredit() throws {
        let credit = ShowCrewCredit.tvSeries(.mock(id: 456, job: "Writer", department: "Writing"))

        let data = try JSONEncoder.theMovieDatabase.encode(credit)
        let decoded = try JSONDecoder.theMovieDatabase.decode(ShowCrewCredit.self, from: data)

        #expect(decoded.id == 456)
        guard case .tvSeries(let tvCredit) = decoded else {
            Issue.record("Expected TV series crew credit")
            return
        }
        #expect(tvCredit.job == "Writer")
        #expect(tvCredit.department == "Writing")
    }

    @Test("id returns movie credit ID")
    func idReturnsMovieCreditID() {
        let credit = ShowCrewCredit.movie(.mock(id: 789))

        #expect(credit.id == 789)
    }

    @Test("id returns TV series credit ID")
    func idReturnsTVSeriesCreditID() {
        let credit = ShowCrewCredit.tvSeries(.mock(id: 101))

        #expect(credit.id == 101)
    }

}
