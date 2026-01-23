//
//  AuthenticateURLMockBuilder.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

final class AuthenticateURLMockBuilder: AuthenticateURLBuilding, @unchecked Sendable {

    var authenticateURLResult: URL
    private(set) var lastRequestToken: String?
    private(set) var lastRedirectURL: URL?

    init() {
        self.authenticateURLResult = {
            guard let url = URL(string: "https://some.domain.com/authenticate") else {
                fatalError()
            }

            return url
        }()
    }

    func authenticateURL(with requestToken: String) -> URL {
        authenticateURL(with: requestToken, redirectURL: nil)
    }

    func authenticateURL(with requestToken: String, redirectURL: URL?) -> URL {
        lastRequestToken = requestToken
        lastRedirectURL = redirectURL

        return authenticateURLResult
    }

}
