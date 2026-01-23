//
//  SessionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct SessionTests {

    @Test("JSON decoding of Session", .tags(.decoding))
    func decodeReturnsSession() throws {
        let expectedResult = Session(
            success: true,
            sessionID: "5f038ae0ee88737033fb7371dfbf6e3f386e9c78"
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(
            Session.self, fromResource: "session"
        )

        #expect(result.success == expectedResult.success)
        #expect(result.sessionID == expectedResult.sessionID)
    }

}
