//
//  AggregrateCrewMemberTests.swift
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
struct AggregrateCrewMemberTests {

    @Test("JSON decoding of AggregrateCrewMember", .tags(.decoding))
    func testDecodeReturnsCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregrateCrewMember.self,
            fromResource: "aggregate-crew-member"
        )

        #expect(result.id == crewMember.id)
        #expect(result.name == crewMember.name)
        #expect(result.originalName == crewMember.originalName)
        #expect(result.gender == crewMember.gender)
        #expect(result.profilePath == crewMember.profilePath)
        #expect(result.jobs == crewMember.jobs)
        #expect(result.knownForDepartment == crewMember.knownForDepartment)
        #expect(result.adult == crewMember.adult)
        #expect(result.totalEpisodeCount == crewMember.totalEpisodeCount)
        #expect(result.popularity == crewMember.popularity)
    }

    private let crewMember = AggregrateCrewMember(
        id: 1_856_851,
        name: "Lance King",
        originalName: "Lance King",
        gender: .unknown,
        profilePath: nil,
        jobs: [
            CrewJob(creditID: "5ff88c4b383df2003c330070", job: "Production Design", episodeCount: 1)
        ],
        knownForDepartment: "Production",
        adult: false,
        totalEpisodeCount: 1,
        popularity: 1.646
    )

}
