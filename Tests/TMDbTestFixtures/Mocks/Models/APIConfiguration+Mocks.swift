//
//  APIConfiguration+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension APIConfiguration {

    static func mock(
        images: ImagesConfiguration = .mock(),
        changeKeys: [String] = ["air_date", "also_known_as"]
    ) -> APIConfiguration {
        APIConfiguration(
            images: images,
            changeKeys: changeKeys
        )
    }

}
