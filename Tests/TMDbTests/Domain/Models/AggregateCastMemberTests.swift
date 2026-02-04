//
//  AggregateCastMemberTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct AggregateCastMemberTests {

    @Test("JSON decoding of AggregateCastMember", .tags(.decoding))
    func decodeCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            AggregateCastMember.self,
            fromResource: "aggregate-cast-member"
        )

        #expect(result.id == castMember.id)
        #expect(result.name == castMember.name)
        #expect(result.originalName == castMember.originalName)
        #expect(result.gender == castMember.gender)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.roles == castMember.roles)
        #expect(result.knownForDepartment == castMember.knownForDepartment)
        #expect(result.isAdultOnly == castMember.isAdultOnly)
        #expect(result.totalEpisodeCount == castMember.totalEpisodeCount)
        #expect(result.popularity == castMember.popularity)
    }

    private let castMember = AggregateCastMember(
        id: 11824,
        name: "Tom Welling",
        originalName: "Tom Peter Welling",
        gender: .male,
        profilePath: URL(string: "/iLyXgCimAWNHSjkTXb7e5KgcMWh.jpg"),
        roles: [
            CastRole(
                creditID: "5257751c760ee36aaa50e171", character: "Clark Kent", episodeCount: 216
            )
        ],
        knownForDepartment: "Acting",
        isAdultOnly: false,
        totalEpisodeCount: 216,
        popularity: 35.505
    )

}
