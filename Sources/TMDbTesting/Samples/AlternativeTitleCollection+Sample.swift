//
//  AlternativeTitleCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension AlternativeTitleCollection {

    /// A sample `AlternativeTitleCollection` populated with representative data.
    static var sample: AlternativeTitleCollection {
        AlternativeTitleCollection(
            id: 1,
            titles: [
                AlternativeTitle(
                    countryCode: "US",
                    title: "Alternative Title 1",
                    type: "Alternative Title"
                ),
                AlternativeTitle(
                    countryCode: "GB",
                    title: "Alternative Title 2",
                    type: "Working Title"
                )
            ]
        )
    }

}
