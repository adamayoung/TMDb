//
//  CastMemberTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CastMemberTests {

    @Test("JSON decoding of CastMember", .tags(.decoding))
    func decodeCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CastMember.self, fromResource: "cast-member"
        )

        #expect(result.id == castMember.id)
        #expect(result.castID == castMember.castID)
        #expect(result.creditID == castMember.creditID)
        #expect(result.name == castMember.name)
        #expect(result.character == castMember.character)
        #expect(result.gender == castMember.gender)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.order == castMember.order)
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
