//
//  ImageMetadata+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension ImageMetadata {

    static func mock(
        filePath: URL = .randomImagePath,
        width: Int = Int.random(in: 10 ... 100),
        height: Int = Int.random(in: 10 ... 100),
        aspectRatio: Float = Float.random(in: 1.0 ... 5.0),
        voteAverage: Float = Float.random(in: 0.0 ... 10.0),
        voteCount: Int = Int.random(in: 0 ... 1000),
        languageCode: String = "en"
    ) -> Self {
        .init(
            filePath: filePath,
            width: width,
            height: height,
            aspectRatio: aspectRatio,
            voteAverage: voteAverage,
            voteCount: voteCount,
            languageCode: languageCode
        )
    }

}

extension [ImageMetadata] {

    static var mocks: [Element] {
        [.mock(), .mock()]
    }

}
