//
//  TaggedImage+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension TaggedImage {

    // swiftlint:disable force_unwrapping
    static func mock(
        id: String = "59164af592514156f50269b6",
        aspectRatio: Double = 0.667,
        filePath: URL = URL(
            string: "/iOpi3ut5DhQIbrVVjlnmfy2U7dI.jpg"
        )!,
        height: Int = 3000,
        width: Int = 2000,
        languageCode: String? = "en",
        countryCode: String? = "US",
        voteAverage: Double = 6.5,
        voteCount: Int = 19,
        imageType: String = "poster",
        media: Media = .mock()
        // swiftlint:enable force_unwrapping
    ) -> TaggedImage {
        TaggedImage(
            id: id,
            aspectRatio: aspectRatio,
            filePath: filePath,
            height: height,
            width: width,
            languageCode: languageCode,
            countryCode: countryCode,
            voteAverage: voteAverage,
            voteCount: voteCount,
            imageType: imageType,
            media: media
        )
    }

}

extension [TaggedImage] {

    static var mocks: [TaggedImage] {
        [.mock(), .mock(), .mock()]
    }

}
