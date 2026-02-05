//
//  BelongsToCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension BelongsToCollection {

    static func mock(
        id: Int = 1241,
        name: String = "Harry Potter Collection",
        posterPath: URL? = URL(string: "/eVPs2Y0LyvTLZn6AP5Z6O2rtiGB.jpg"),
        backdropPath: URL? = URL(string: "/kmEsQL2vOTA0jnM28fXS45Ky8kX.jpg")
    ) -> BelongsToCollection {
        BelongsToCollection(
            id: id,
            name: name,
            posterPath: posterPath,
            backdropPath: backdropPath
        )
    }

}
