//
//  Token+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension Token {

    static func mock(
        success: Bool = true,
        requestToken: String = "10530f2246e244555d122016db7c65599c8d6f4d",
        expiresAt: Date = Date(timeIntervalSince1970: 1_705_956_596)
    ) -> Token {
        Token(
            success: success,
            requestToken: requestToken,
            expiresAt: expiresAt
        )
    }

}
