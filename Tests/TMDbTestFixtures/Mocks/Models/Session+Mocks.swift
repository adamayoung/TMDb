//
//  Session+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension Session {

    static func mock(
        success: Bool = true,
        sessionID: String = "abc123"
    ) -> Session {
        Session(
            success: success,
            sessionID: sessionID
        )
    }

}
