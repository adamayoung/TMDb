//
//  GuestSessionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct GuestSessionTests {

    @Test("JSON decoding of GuestSession", .tags(.decoding))
    func decodeReturnsGuestSession() throws {
        let expectedResult = GuestSession(
            success: true,
            guestSessionID: "hg8r6c2clzw06bdtjt3whqghd44pki46",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )

        let result = try JSONDecoder.theMovieDatabaseAuth.decode(
            GuestSession.self, fromResource: "guest-session"
        )

        #expect(result.success == expectedResult.success)
        #expect(result.guestSessionID == expectedResult.guestSessionID)
        #expect(result.expiresAt == expectedResult.expiresAt)
    }

}
