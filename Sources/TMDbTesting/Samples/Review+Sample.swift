//
//  Review+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Review {

    /// A sample `Review` for use in previews and tests.
    static var sample: Review {
        Review(
            id: "1",
            author: "Author Name",
            content: "Some review content"
        )
    }

}
