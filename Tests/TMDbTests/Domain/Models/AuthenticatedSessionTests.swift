//
//  AuthenticatedSessionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct AuthenticatedSessionTests {

    @Test("init stores the account identifier and session")
    func initStoresAccountIDAndSession() {
        let session = Session(success: true, sessionID: "abc123")

        let authenticatedSession = AuthenticatedSession(accountID: 42, session: session)

        #expect(authenticatedSession.accountID == 42)
        #expect(authenticatedSession.session == session)
    }

    @Test("equates only when both the account identifier and session match")
    func equatable() {
        let session = Session(success: true, sessionID: "abc123")
        let other = Session(success: true, sessionID: "xyz789")

        #expect(
            AuthenticatedSession(accountID: 42, session: session)
                == AuthenticatedSession(accountID: 42, session: session)
        )
        #expect(
            AuthenticatedSession(accountID: 42, session: session)
                != AuthenticatedSession(accountID: 43, session: session)
        )
        #expect(
            AuthenticatedSession(accountID: 42, session: session)
                != AuthenticatedSession(accountID: 42, session: other)
        )
    }

    @Test("equal values hash equally")
    func hashable() {
        let session = Session(success: true, sessionID: "abc123")
        let first = AuthenticatedSession(accountID: 42, session: session)
        let second = AuthenticatedSession(accountID: 42, session: session)

        #expect(Set([first, second]).count == 1)
    }

}
