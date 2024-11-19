//
//  JSONEncoder+TMDbTests.swift
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

@Suite
struct JSONEncoderTMDbTests {

    var jsonEncoder: JSONEncoder!
    var dateFormatter: DateFormatter!

    init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-ddd"
        self.jsonEncoder = JSONEncoder.theMovieDatabase
    }

    @Test("encoder encodes object")
    func theMovieDatabaseEncoderEncodesObject() throws {
        let value = try SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: #require(dateFormatter.date(from: "1990-01-02"))
        )

        let expectedIDResult = "\"id\":\"abc123\""
        let expectedFirstNameResult = "\"first_name\":\"Adam\""
        let expectedDataOfBirthResult = "\"date_of_birth\":\"1990-01-02\""

        let data = try jsonEncoder.encode(value)
        let dataAsString = try #require(String(data: data, encoding: .utf8))

        #expect(dataAsString.contains(expectedIDResult))
        #expect(dataAsString.contains(expectedFirstNameResult))
        #expect(dataAsString.contains(expectedDataOfBirthResult))
    }

}

extension JSONEncoderTMDbTests {

    private struct SomeThing: Encodable, Equatable {

        let id: String
        let firstName: String
        let dateOfBirth: Date

    }

}
