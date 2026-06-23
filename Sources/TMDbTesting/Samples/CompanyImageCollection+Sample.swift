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
                    filePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1000,
                    height: 1000,
                    aspectRatio: 1.0,
                    voteAverage: 5.0,
                    voteCount: 1,
                    languageCode: "en"
                )
            ]
        )
    }

}
