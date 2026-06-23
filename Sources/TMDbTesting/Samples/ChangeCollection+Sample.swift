//
//  ChangeCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ChangeCollection {

    /// A sample `ChangeCollection` for use in tests and previews.
    static var sample: ChangeCollection {
        ChangeCollection(
            changes: [
                Change(
                    key: "images",
                    items: [
                        ChangeItem(
                            id: "6a391743dbad65b03d24d3d2",
                            action: "updated",
                            time: Date(timeIntervalSince1970: 1_782_212_803),
                            languageCode: "en",
                            countryCode: "US",
                            value: .string("/uzRY3Rs3mGItB3X40Vo6inBejNf.jpg"),
                            originalValue: .string("/uzRY3Rs3mGItB3X40Vo6inBejNf.jpg")
                        )
                    ]
                )
            ]
        )
    }

}
