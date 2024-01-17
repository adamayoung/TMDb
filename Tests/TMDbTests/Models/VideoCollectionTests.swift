//
//  VideoCollectionTests.swift
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

@testable import TMDb
import XCTest

final class VideoCollectionTests: XCTestCase {

    func testDecodeReturnsVideoCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(VideoCollection.self, fromResource: "video-collection")

        XCTAssertEqual(result.id, videoCollection.id)
        XCTAssertEqual(result.results, videoCollection.results)
    }

    private let videoCollection = VideoCollection(
        id: 550,
        results: [
            VideoMetadata(
                id: "533ec654c3a36854480003eb",
                name: "Trailer 1",
                site: "YouTube",
                key: "SUXWAEX2jlg",
                type: .trailer,
                size: .s720
            )
        ]
    )

}
