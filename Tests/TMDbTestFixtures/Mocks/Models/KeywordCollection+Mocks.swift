//
//  KeywordCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension KeywordCollection {

    static func mock(
        id: Int = 1,
        keywords: [Keyword] = [
            Keyword(id: 1, name: "Keyword 1"),
            Keyword(id: 2, name: "Keyword 2")
        ]
    ) -> KeywordCollection {
        KeywordCollection(
            id: id,
            keywords: keywords
        )
    }

}
