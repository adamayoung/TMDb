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
            id: "5b1c13b9c3a36848f2026384",
            author: "Goddard",
            content: """
            Pretty awesome movie.  It shows what one crazy person can convince other crazy people to \
            do.  Everyone needs something to believe in.  I recommend Jesus Christ, but they want \
            Tyler Durden.
            """
        )
    }

}
