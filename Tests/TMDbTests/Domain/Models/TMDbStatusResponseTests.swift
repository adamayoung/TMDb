//
//  TMDbStatusResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TMDbStatusResponseTests {

    func testDecodeReturnsStatusResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TMDbStatusResponse.self,
            fromResource: "error-status-response"
        )

        #expect(result.success == statusResponse.success)
        #expect(result.statusCode == statusResponse.statusCode)
        #expect(result.statusMessage == statusResponse.statusMessage)
    }

    private let statusResponse = TMDbStatusResponse(
        success: false,
        statusCode: 34,
        statusMessage: "The resource you requested could not be found."
    )

}
