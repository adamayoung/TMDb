//
//  V4RequestToken+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension V4RequestToken {

    /// A sample `V4RequestToken` populated with representative data.
    static var sample: V4RequestToken {
        V4RequestToken(
            success: true,
            requestToken: """
            eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCIsInNjb3Blc\
            yI6WyJwZW5kaW5nX3JlcXVlc3RfdG9rZW4iXSwidmVyc2lvbiI6Mn0.00000000000000000000000000000000
            """
        )
    }

}
