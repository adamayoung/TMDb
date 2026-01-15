//
//  MovieReleaseDatesByCountryTests.swift
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
struct MovieReleaseDatesByCountryTests {

    @Test("decodes from JSON", .tags(.decoding))
    func decodesFromJSON() throws {
        let expectedResult = MovieReleaseDatesByCountry(
            countryCode: "US",
            releaseDates: [
                ReleaseDate(
                    certification: "R",
                    languageCode: "",
                    note: "Los Angeles, California",
                    releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-15")!,
                    type: .premiere
                ),
                ReleaseDate(
                    certification: "R",
                    languageCode: "",
                    note: "",
                    releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-15")!,
                    type: .theatrical
                )
            ]
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            MovieReleaseDatesByCountry.self,
            fromResource: "movie-release-dates-by-country"
        )

        #expect(result == expectedResult)
    }

}
