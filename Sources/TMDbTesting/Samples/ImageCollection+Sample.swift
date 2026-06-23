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
        let poster = ImageMetadata(
            filePath: URL(string: "/nu7FEmC4zBaZ7c3QYmVpDlZa2H0.jpg")
                ?? URL(fileURLWithPath: "/"),
            width: 2000,
            height: 3000,
            aspectRatio: 0.667,
            voteAverage: 5.928,
            voteCount: 21,
            languageCode: "pt"
        )

        let logo = ImageMetadata(
            filePath: URL(string: "/7Uqhv24pGJs4Ns31NoOPWFJGWNG.png")
                ?? URL(fileURLWithPath: "/"),
            width: 1804,
            height: 389,
            aspectRatio: 4.638,
            voteAverage: 8.034,
            voteCount: 5,
            languageCode: "en"
        )

        let backdrop = ImageMetadata(
            filePath: URL(string: "/c6OLXfKAk5BKeR6broC8pYiCquX.jpg")
                ?? URL(fileURLWithPath: "/"),
            width: 2560,
            height: 1440,
            aspectRatio: 1.778,
            voteAverage: 6.14,
            voteCount: 32,
            languageCode: nil
        )

        return ImageCollection(
            id: 550,
            posters: [poster],
            logos: [logo],
            backdrops: [backdrop]
        )
    }

}
