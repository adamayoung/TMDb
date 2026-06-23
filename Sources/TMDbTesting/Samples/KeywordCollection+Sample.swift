//
//  KeywordCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension KeywordCollection {

    /// A sample `KeywordCollection` populated with representative data.
    static var sample: KeywordCollection {
        KeywordCollection(
            id: 1,
            keywords: [
                Keyword(id: 1, name: "Keyword 1"),
                Keyword(id: 2, name: "Keyword 2")
            ]
        )
    }

}
