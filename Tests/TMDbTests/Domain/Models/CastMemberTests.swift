//
//  CastMemberTests.swift
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

final class CastMemberTests: XCTestCase {

    func testDecodeReturnsCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(CastMember.self, fromResource: "cast-member")

        XCTAssertEqual(result.id, castMember.id)
        XCTAssertEqual(result.castID, castMember.castID)
        XCTAssertEqual(result.creditID, castMember.creditID)
        XCTAssertEqual(result.name, castMember.name)
        XCTAssertEqual(result.character, castMember.character)
        XCTAssertEqual(result.gender, castMember.gender)
        XCTAssertEqual(result.profilePath, castMember.profilePath)
        XCTAssertEqual(result.order, castMember.order)
    }

    private let castMember = CastMember(
        id: 819,
        castID: 4,
        creditID: "52fe4250c3a36847f80149f3",
        name: "Edward Norton",
        character: "The Narrator",
        gender: .male,
        profilePath: URL(string: "/eIkFHNlfretLS1spAcIoihKUS62.jpg"),
        order: 0
    )

}
