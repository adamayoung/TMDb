//
//  ProductionCompany+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension ProductionCompany {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        originCountry: String = .randomString,
        logoPath: URL? = .randomImagePath
    ) -> Self {
        .init(
            id: id,
            name: name ?? "Production Company \(id)",
            originCountry: originCountry,
            logoPath: logoPath
        )
    }

}

extension [ProductionCompany] {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
