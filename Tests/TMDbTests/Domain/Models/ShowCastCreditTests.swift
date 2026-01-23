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

}
