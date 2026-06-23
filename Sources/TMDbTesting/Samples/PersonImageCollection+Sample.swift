//
//  PersonImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension PersonImageCollection {

    /// A sample `PersonImageCollection` for use in tests and previews.
    static var sample: PersonImageCollection {
        PersonImageCollection(
            id: 287,
            profiles: [
                ImageMetadata(
                    filePath: URL(string: "/m09Y1YfPPeNYYUSHnnVqahkrC1o.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1684,
                    height: 2528,
                    aspectRatio: 0.666,
                    voteAverage: 8.362,
                    voteCount: 6,
                    languageCode: nil
                )
            ]
        )
    }

}
