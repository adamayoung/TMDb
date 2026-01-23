//
//  ProductionCompany+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ProductionCompany {

    static func mock(
        id: Int = 1,
        name: String = "Production Company Name",
        originCountry: String = "Production Origin Country",
        logoPath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
    ) -> ProductionCompany {
        ProductionCompany(
            id: id,
            name: name,
            originCountry: originCountry,
            logoPath: logoPath
        )
    }

}

extension [ProductionCompany] {

    static var mocks: [ProductionCompany] {
        [.mock(), .mock(), .mock()]
    }

}
