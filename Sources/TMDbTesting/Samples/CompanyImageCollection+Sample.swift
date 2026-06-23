//
//  CompanyImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension CompanyImageCollection {

    /// A sample `CompanyImageCollection` for use in tests and previews.
    static var sample: CompanyImageCollection {
        CompanyImageCollection(
            id: 1,
            logos: [
                ImageMetadata(
                    filePath: URL(string: "/tlVSws0RvvtPBwViUyOFAO0vcQS.png")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1000,
                    height: 329,
                    aspectRatio: 3.0395136778115504,
                    voteAverage: 3.334,
                    voteCount: 1,
                    languageCode: nil
                )
            ]
        )
    }

}
