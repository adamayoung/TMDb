//
//  Network+Mocks.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import TMDb

extension Network {

    // swift-format-ignore: NeverForceUnwrap
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

    // swift-format-ignore: NeverForceUnwrap
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
