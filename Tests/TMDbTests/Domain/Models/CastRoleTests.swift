//
//  CastRoleTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct CastRoleTests {

    @Test("JSON decoding of CastRole")
    func decodeReturnsCastRole() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CastRole.self,
            fromResource: "cast-role"
        )

        #expect(result == castRole)
    }

}

extension CastRoleTests {

    private var castRole: CastRole {
        CastRole(
            creditID: "52fe4250c3a36847f80149f3",
            character: "Jack Sparrow",
            episodeCount: 24
        )
    }

}
