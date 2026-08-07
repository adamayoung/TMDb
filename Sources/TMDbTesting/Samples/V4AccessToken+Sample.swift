//
//  V4AccessToken+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension V4AccessToken {

    /// A sample `V4AccessToken` populated with representative data.
    static var sample: V4AccessToken {
        V4AccessToken(
            success: true,
            accessToken: """
            eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMCIsInNjb3Blc\
            yI6WyJhcGlfcmVhZCIsImFwaV93cml0ZSJdLCJ2ZXJzaW9uIjoyfQ.000000000000000000000000000000000
            """,
            accountID: "1a2b3c4d5e6f7a8b9c0d1e2f"
        )
    }

}
