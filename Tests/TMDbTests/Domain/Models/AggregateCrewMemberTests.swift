//
//  AggregateCrewMemberTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct AggregateCrewMemberTests {

    @Test("JSON decoding of AggregateCrewMember", .tags(.decoding))
    func decodeCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregateCrewMember.self,
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

    private let crewMember = AggregateCrewMember(
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
