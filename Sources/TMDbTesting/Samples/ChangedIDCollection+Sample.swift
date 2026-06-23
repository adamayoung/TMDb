//
//  ChangedIDCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ChangedIDCollection {

    ///
    /// A sample changed ID collection, for use in tests and previews.
    ///
    static var sample: ChangedIDCollection {
        ChangedIDCollection(
            results: [
                ChangedID(id: 1, adult: false),
                ChangedID(id: 2, adult: false)
            ],
            page: 1,
            totalPages: 1,
            totalResults: 2
        )
    }

}
