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
            id: 550,
            keywords: [
                Keyword(id: 851, name: "dual identity"),
                Keyword(id: 818, name: "based on novel or book")
            ]
        )
    }

}
