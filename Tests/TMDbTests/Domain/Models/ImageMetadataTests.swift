//
//  ImageMetadataTests.swift
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

final class ImageMetadataTests: XCTestCase {

    func testIDReturnsFilePath() {
        XCTAssertEqual(imageMetadata.id, imageMetadata.filePath)
    }

    func testDecodeReturnsImageMetadata() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(ImageMetadata.self, fromResource: "image-metadata")

        XCTAssertEqual(result.filePath, imageMetadata.filePath)
        XCTAssertEqual(result.width, imageMetadata.width)
        XCTAssertEqual(result.height, imageMetadata.height)
        XCTAssertEqual(result.aspectRatio, imageMetadata.aspectRatio)
        XCTAssertEqual(result.voteAverage, imageMetadata.voteAverage)
        XCTAssertEqual(result.voteCount, imageMetadata.voteCount)
        XCTAssertEqual(result.languageCode, imageMetadata.languageCode)
    }

    private let imageMetadata = ImageMetadata(
        filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!,
        width: 1280,
        height: 720,
        aspectRatio: 1.77777777777778,
        voteAverage: 5.7,
        voteCount: 957,
        languageCode: "en"
    )

}
