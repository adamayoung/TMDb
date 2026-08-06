//
//  V4AccessTokenTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .authentication))
struct V4AccessTokenTests {

    @Test("JSON decoding of V4AccessToken", .tags(.decoding))
    func decodeReturnsV4AccessToken() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            V4AccessToken.self,
            fromResource: "v4-access-token"
        )

        #expect(result.success == true)
        #expect(result.accessToken.hasPrefix("eyJ"))
        #expect(result.accountID == "1a2b3c4d5e6f7a8b9c0d1e2f")
    }

}
