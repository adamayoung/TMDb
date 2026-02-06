//
//  CompanyAlternativeName+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CompanyAlternativeName {

    static func mock(
        name: String = "Some Alternative Name",
        type: String = "doing business as"
    ) -> CompanyAlternativeName {
        CompanyAlternativeName(
            name: name,
            type: type
        )
    }

}

extension [CompanyAlternativeName] {

    static var mocks: [Element] {
        [.mock(), .mock()]
    }

}
