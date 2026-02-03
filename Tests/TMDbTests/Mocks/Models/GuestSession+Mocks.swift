//
//  GuestSession+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension GuestSession {

    static func mock(
        success: Bool = true,
        guestSessionID: String = "jdbqej40d9b562zk42ma8u4tp1saup5q",
        expiresAt: Date = Date(timeIntervalSince1970: 1_705_956_596)
    ) -> GuestSession {
        GuestSession(
            success: success,
            guestSessionID: guestSessionID,
            expiresAt: expiresAt
        )
    }

}
