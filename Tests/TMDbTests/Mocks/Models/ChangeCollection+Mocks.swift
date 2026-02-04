//
//  ChangeCollection+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ChangeCollection {

    static func mock(
        changes: [Change] = [
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
    ) -> ChangeCollection {
        ChangeCollection(changes: changes)
    }

}
