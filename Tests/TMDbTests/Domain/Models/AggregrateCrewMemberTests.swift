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

@testable import TMDb
import XCTest

final class AggregrateCrewMemberTests: XCTestCase {

    func testDecodeReturnsCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregrateCrewMember.self,
            fromResource: "aggregate-crew-member"
        )

        XCTAssertEqual(result.id, crewMember.id)
        XCTAssertEqual(result.name, crewMember.name)
        XCTAssertEqual(result.originalName, crewMember.originalName)
        XCTAssertEqual(result.gender, crewMember.gender)
        XCTAssertEqual(result.profilePath, crewMember.profilePath)
        XCTAssertEqual(result.jobs, crewMember.jobs)
        XCTAssertEqual(result.knownForDepartment, crewMember.knownForDepartment)
        XCTAssertEqual(result.adult, crewMember.adult)
        XCTAssertEqual(result.totalEpisodeCount, crewMember.totalEpisodeCount)
        XCTAssertEqual(result.popularity, crewMember.popularity)
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
