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
            id: 1,
            profiles: [
                ImageMetadata(
                    filePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 100,
                    height: 100,
                    aspectRatio: 1,
                    voteAverage: 5,
                    voteCount: 100,
                    languageCode: "en"
                )
            ]
        )
    }

}
