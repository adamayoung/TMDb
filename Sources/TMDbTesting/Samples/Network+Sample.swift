//
//  Network+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Network {

    /// A sample `Network` for use in tests and previews.
    static var sample: Network {
        Network(
            id: 49,
            name: "HBO",
            logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
            originCountry: "US",
            headquarters: "New York City, New York",
            homepage: URL(string: "https://www.hbo.com")
        )
    }

}
