//
//  VideoMetadataTests.swift
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
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct VideoMetadataTests {

    @Test("JSON decoding of VideoMetadata", .tags(.decoding))
    func decodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            VideoMetadata.self, fromResource: "video-metadata")

        #expect(result.id == videoMetadata.id)
        #expect(result.name == videoMetadata.name)
        #expect(result.site == videoMetadata.site)
        #expect(result.key == videoMetadata.key)
        #expect(result.type == videoMetadata.type)
        #expect(result.size == videoMetadata.size)
    }

    private let videoMetadata = VideoMetadata(
        id: "533ec654c3a36854480003eb",
        name: "Trailer 1",
        site: "YouTube",
        key: "SUXWAEX2jlg",
        type: .trailer,
        size: .s720
    )

}
