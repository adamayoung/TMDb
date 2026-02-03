//
//  AccountStatesTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct AccountStatesTests {

    @Test("JSON decoding of AccountStates with rating", .tags(.decoding))
    func decodeAccountStatesWithRating() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AccountStates.self,
            fromResource: "account-states"
        )

        #expect(result.id == 550)
        #expect(result.favorite == true)
        #expect(result.rated?.value == 8.5)
        #expect(result.watchlist == false)
    }

    @Test("JSON decoding of AccountStates without rating", .tags(.decoding))
    func decodeAccountStatesWithoutRating() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AccountStates.self,
            fromResource: "account-states-unrated"
        )

        #expect(result.id == 550)
        #expect(result.favorite == false)
        #expect(result.rated == nil)
        #expect(result.watchlist == true)
    }

}
