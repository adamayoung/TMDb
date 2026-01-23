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

}
