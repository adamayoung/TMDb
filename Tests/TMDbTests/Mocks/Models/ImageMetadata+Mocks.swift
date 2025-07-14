//
//  ImageMetadata+Mocks.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import TMDb

extension ImageMetadata {

    // swift-format-ignore: NeverForceUnwrap
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

}

extension [ImageMetadata] {

    static var mocks: [Element] {
        [.mock(), .mock()]
    }

}
