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
            id: 550,
            titles: [
                AlternativeTitle(
                    countryCode: "RU",
                    title: "Boytsovskiy klub",
                    type: "romanization"
                ),
                AlternativeTitle(
                    countryCode: "CN",
                    title: "搏击会",
                    type: ""
                )
            ]
        )
    }

}
