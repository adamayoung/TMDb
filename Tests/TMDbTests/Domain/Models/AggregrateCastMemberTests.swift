//
//  AggregrateCastMemberTests.swift
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

final class AggregrateCastMemberTests: XCTestCase {

    func testDecodeReturnsCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregrateCastMember.self,
            fromResource: "aggregate-cast-member"
        )

        XCTAssertEqual(result.id, castMember.id)
        XCTAssertEqual(result.name, castMember.name)
        XCTAssertEqual(result.originalName, castMember.originalName)
        XCTAssertEqual(result.gender, castMember.gender)
        XCTAssertEqual(result.profilePath, castMember.profilePath)
        XCTAssertEqual(result.roles, castMember.roles)
        XCTAssertEqual(result.knownForDepartment, castMember.knownForDepartment)
        XCTAssertEqual(result.adult, castMember.adult)
        XCTAssertEqual(result.totalEpisodeCount, castMember.totalEpisodeCount)
        XCTAssertEqual(result.popularity, castMember.popularity)
    }

    private let castMember = AggregrateCastMember(
        id: 11824,
        name: "Tom Welling",
        originalName: "Tom Peter Welling",
        gender: .male,
        profilePath: URL(string: "/iLyXgCimAWNHSjkTXb7e5KgcMWh.jpg"),
        roles: [
            CastRole(creditID: "5257751c760ee36aaa50e171", character: "Clark Kent", episodeCount: 216)
        ],
        knownForDepartment: "Acting",
        adult: false,
        totalEpisodeCount: 216,
        popularity: 35.505
    )

}
