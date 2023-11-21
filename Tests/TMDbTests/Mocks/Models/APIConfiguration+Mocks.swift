//
//  APIConfiguration+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension APIConfiguration {

    static func mock(
        images: ImagesConfiguration = .mock(),
        changeKeys: [String] = ["air_date", "also_known_as"]
    ) -> Self {
        .init(
            images: images,
            changeKeys: changeKeys
        )
    }

}
