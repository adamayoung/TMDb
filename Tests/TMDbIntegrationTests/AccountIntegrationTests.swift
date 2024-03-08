//
//  File.swift
//  
//
//  Created by Adam Young on 08/03/2024.
//

import TMDb
import XCTest

final class AccountIntegrationTests: XCTestCase {

    var accountService: AccountService!
    var authenticationService: AuthenticationService!
    var session: Session!

    override func setUp() async throws {
        try await super.setUp()
        try configureTMDb()

        authenticationService = AuthenticationService()
        let credential = try tmdbCredential()
        self.session = try await authenticationService.createSession(withCredential: credential)

        accountService = AccountService()
    }

    override func tearDown() async throws {
        accountService = nil
        try await authenticationService.deleteSession(session)
        authenticationService = nil
        session = nil
        try await super.tearDown()
    }

    func testDetails() async throws {
        let details = try await accountService.details(session: session)

        XCTAssertGreaterThan(details.id, 0)
    }

}
