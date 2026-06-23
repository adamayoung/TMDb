//
//  Token+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Token {

    /// A sample `Token` populated with representative data.
    static var sample: Token {
        Token(
            success: true,
            requestToken: "10530f2246e244555d122016db7c65599c8d6f4d",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )
    }

}
