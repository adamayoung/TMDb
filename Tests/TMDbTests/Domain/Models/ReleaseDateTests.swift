//
//  ReleaseDateTests.swift
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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ReleaseDateTests {

    @Test("decodes from JSON", .tags(.decoding))
    func decodesFromJSON() throws {
        let expectedResult = ReleaseDate(
            certification: "R",
            languageCode: "",
            note: "Los Angeles, California",
            releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-15")!,
            type: .premiere
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            ReleaseDate.self,
            fromResource: "release-date"
        )

        #expect(result == expectedResult)
    }

}
