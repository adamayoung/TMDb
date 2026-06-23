//
//  NetworkAlternativeName+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension NetworkAlternativeName {

    /// A sample `NetworkAlternativeName` for use in tests and previews.
    static var sample: NetworkAlternativeName {
        NetworkAlternativeName(
            name: "HBO Network",
            type: ""
        )
    }

}

public extension [NetworkAlternativeName] {

    /// A sample array of `NetworkAlternativeName` values for use in tests and previews.
    static var samples: [NetworkAlternativeName] {
        [.sample]
    }

}
