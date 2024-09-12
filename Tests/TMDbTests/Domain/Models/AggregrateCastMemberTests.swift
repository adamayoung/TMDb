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

import Foundation
import Testing
@testable import TMDb

@Suite
struct AggregrateCastMemberTests {

    @Test("JSON decoding of AggregrateCastMember", .tags(.decoding))
    func testDecodeReturnsCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregrateCastMember.self,
            fromResource: "aggregate-cast-member"
        )

        #expect(result.id == castMember.id)
        #expect(result.name == castMember.name)
        #expect(result.originalName == castMember.originalName)
        #expect(result.gender == castMember.gender)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.roles == castMember.roles)
        #expect(result.knownForDepartment == castMember.knownForDepartment)
        #expect(result.adult == castMember.adult)
        #expect(result.totalEpisodeCount == castMember.totalEpisodeCount)
        #expect(result.popularity == castMember.popularity)
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
