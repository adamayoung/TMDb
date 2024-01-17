//
//  PersonImageCollectionTests.swift
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

final class PersonImageCollectionTests: XCTestCase {

    func testDecodeReturnsPersonImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonImageCollection.self, fromResource: "person-image-collection")

        XCTAssertEqual(result.id, personImageCollection.id)
        XCTAssertEqual(result.profiles, personImageCollection.profiles)
    }

    private let personImageCollection = PersonImageCollection(
        id: 66633,
        profiles: [
            ImageMetadata(
                filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!,
                width: 546,
                height: 819,
                aspectRatio: 0.666666666666667,
                voteAverage: 7.21,
                voteCount: 345
            ),
            ImageMetadata(
                filePath: URL(string: "/lYqC8Amj4owX05xQg5Yo7uUHgah.jpg")!,
                width: 2000,
                height: 3000,
                aspectRatio: 0.666666666666667,
                voteAverage: 4.21,
                voteCount: 3
            )
        ]
    )

}
