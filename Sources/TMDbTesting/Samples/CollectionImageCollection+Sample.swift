//
//  CollectionImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension CollectionImageCollection {

    /// A sample `CollectionImageCollection` populated with representative data.
    static var sample: CollectionImageCollection {
        CollectionImageCollection(
            id: 10,
            posters: [
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
            ],
            backdrops: [
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
