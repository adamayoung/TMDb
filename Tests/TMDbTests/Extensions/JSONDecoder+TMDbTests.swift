//
//  JSONDecoder+TMDbTests.swift
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

final class JSONDecoderTMDbTests: XCTestCase {

    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddd"
        return dateFormatter
    }

    func testTheMovieDatabaseDecoderDecodesObject() throws {
        let expectedResult = SomeThing(
            id: "abc123",
            firstName: "Adam",
            dateOfBirth: Self.dateFormatter.date(from: "1990-01-02")!
        )

        let jsonString = """
        {
            "id": "abc123",
            "first_name": "Adam",
            "date_of_birth": "1990-01-02"
        }
        """
        let data = Data(jsonString.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(SomeThing.self, from: data)

        XCTAssertEqual(result, expectedResult)
    }

    private struct SomeThing: Decodable, Equatable {

        let id: String
        let firstName: String
        let dateOfBirth: Date

    }

}
