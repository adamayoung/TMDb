//
//  AlternativeTitleCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension AlternativeTitleCollection {

    static func mock(
        id: Int = 1,
        titles: [AlternativeTitle] = [
            AlternativeTitle(countryCode: "US", title: "Alternative Title 1", type: "Alternative Title"),
            AlternativeTitle(countryCode: "GB", title: "Alternative Title 2", type: "Working Title")
        ]
    ) -> AlternativeTitleCollection {
        AlternativeTitleCollection(
            id: id,
            titles: titles
        )
    }

}
