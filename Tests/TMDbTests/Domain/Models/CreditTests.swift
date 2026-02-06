//
//  CreditTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .credit))
struct CreditTests {

    @Test("JSON decoding of Credit", .tags(.decoding))
    func decodeCredit() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Credit.self,
            fromResource: "credit"
        )

        #expect(result.id == "52542282760ee313280017f9")
        #expect(result.creditType == .cast)
        #expect(result.department == "Acting")
        #expect(result.job == "Actor")
        #expect(result.mediaType == "tv")
        #expect(result.person.id == 17419)
        #expect(result.person.name == "Bryan Cranston")

        if case .tvSeries(let tvSeries) = result.media {
            #expect(tvSeries.id == 1396)
            #expect(tvSeries.name == "Breaking Bad")
        } else {
            Issue.record("Expected TV series media type")
        }
    }

}
