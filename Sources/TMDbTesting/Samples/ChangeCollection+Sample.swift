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
                    key: "title",
                    items: [
                        ChangeItem(
                            id: "1",
                            action: "updated",
                            time: Date(timeIntervalSince1970: 1_704_067_200),
                            languageCode: "en",
                            countryCode: "US",
                            value: .string("New Title"),
                            originalValue: .string("Old Title")
                        )
                    ]
                )
            ]
        )
    }

}
