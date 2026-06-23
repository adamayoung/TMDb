//
//  ImageCollection+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ImageCollection {

    ///
    /// A sample image collection, for use in tests and previews.
    ///
    static var sample: ImageCollection {
        let image = ImageMetadata(
            filePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                ?? URL(fileURLWithPath: "/"),
            width: 100,
            height: 100,
            aspectRatio: 1,
            voteAverage: 5,
            voteCount: 100,
            languageCode: "en"
        )

        return ImageCollection(
            id: 1,
            posters: [image],
            logos: [image],
            backdrops: [image]
        )
    }

}
