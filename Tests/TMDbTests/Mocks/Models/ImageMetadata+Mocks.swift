//
//  ImageMetadata+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension ImageMetadata {

    // swiftlint:disable force_unwrapping
    static func mock(
        filePath: URL = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!,
        width: Int = 100,
        height: Int = 100,
        aspectRatio: Float = 1,
        voteAverage: Float = 5,
        voteCount: Int = 100,
        languageCode: String = "en"
    ) -> ImageMetadata {
        ImageMetadata(
            filePath: filePath,
            width: width,
            height: height,
            aspectRatio: aspectRatio,
            voteAverage: voteAverage,
            voteCount: voteCount,
            languageCode: languageCode
        )
    }
    // swiftlint:enable force_unwrapping

}

extension [ImageMetadata] {

    static var mocks: [Element] {
        [.mock(), .mock()]
    }

}
