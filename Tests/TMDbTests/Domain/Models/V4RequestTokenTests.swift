//
//  V4RequestTokenTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .authentication))
struct V4RequestTokenTests {

    @Test("JSON decoding of V4RequestToken", .tags(.decoding))
    func decodeReturnsV4RequestToken() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            V4RequestToken.self,
            fromResource: "v4-request-token"
        )

        #expect(result.success == true)
        #expect(result.requestToken.hasPrefix("eyJ"))
    }

}
