//
//  GuestSession+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension GuestSession {

    /// A sample `GuestSession` for use in tests and previews.
    static var sample: GuestSession {
        GuestSession(
            success: true,
            guestSessionID: "12b10e0b13045a3e3a8c2def2dc94d28",
            expiresAt: Date(timeIntervalSince1970: 1_782_337_840)
        )
    }

}
