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
            guestSessionID: "jdbqej40d9b562zk42ma8u4tp1saup5q",
            expiresAt: Date(timeIntervalSince1970: 1_705_956_596)
        )
    }

}
