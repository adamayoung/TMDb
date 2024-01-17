//
//  ImageMetadata+Mocks.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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
