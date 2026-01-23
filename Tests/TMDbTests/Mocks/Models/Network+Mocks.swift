//
//  Network+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Network {

    static func mock(
        id: Int = 49,
        name: String = "HBO",
        logoPath: URL? = URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
        originCountry: String? = "US",
        headquarters: String? = "New York City, New York",
        homepage: URL? = URL(string: "https://www.hbo.com")
    ) -> Network {
        Network(
            id: id,
            name: name,
            logoPath: logoPath,
            originCountry: originCountry,
            headquarters: headquarters,
            homepage: homepage
        )
    }

    static var hbo: Network {
        Network.mock(
            id: 49,
            name: "HBO",
            logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
            originCountry: "US",
            headquarters: "New York City, New York",
            homepage: URL(string: "https://www.hbo.com")
        )
    }

}
