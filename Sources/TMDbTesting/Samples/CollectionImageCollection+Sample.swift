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
                    filePath: URL(string: "/6mHkagjziBPth2Mx0VpEercocm4.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1000,
                    height: 1500,
                    aspectRatio: 0.667,
                    voteAverage: 8.034,
                    voteCount: 6,
                    languageCode: "fr"
                )
            ],
            backdrops: [
                ImageMetadata(
                    filePath: URL(string: "/itH1Wlzwf6yTNa7fVkYMVUwXlhR.jpg")
                        ?? URL(fileURLWithPath: "/"),
                    width: 1920,
                    height: 1080,
                    aspectRatio: 1.778,
                    voteAverage: 8.034,
                    voteCount: 5,
                    languageCode: "en"
                )
            ]
        )
    }

}
