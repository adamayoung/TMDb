//
//  CompanyAlternativeNameCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension CompanyAlternativeNameCollection {

    /// A sample `CompanyAlternativeNameCollection` for use in tests and previews.
    static var sample: CompanyAlternativeNameCollection {
        CompanyAlternativeNameCollection(
            id: 1,
            results: [
                CompanyAlternativeName(
                    name: "Some Alternative Name",
                    type: "doing business as"
                )
            ]
        )
    }

}
