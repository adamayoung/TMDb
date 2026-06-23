//
//  Session+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Session {

    /// A sample `Session` populated with representative data.
    static var sample: Session {
        Session(
            success: true,
            sessionID: "abc123"
        )
    }

}
