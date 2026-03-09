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
        #expect(result.originalName == castMember.originalName)
        #expect(result.character == castMember.character)
        #expect(result.knownForDepartment == castMember.knownForDepartment)
        #expect(result.gender == castMember.gender)
        #expect(result.profilePath == castMember.profilePath)
        #expect(result.popularity == castMember.popularity)
        #expect(result.order == castMember.order)
        #expect(result.isAdultOnly == castMember.isAdultOnly)
    }

    @Test(
        "JSON decoding of CastMember without optional fields",
        .tags(.decoding)
    )
    func decodeCastMemberWithoutOptionalFields() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CastMember.self,
            fromResource: "cast-member-without-optional-fields"
        )

        #expect(result.id == 819)
        #expect(result.castID == nil)
        #expect(result.creditID == "52fe4250c3a36847f80149f3")
        #expect(result.name == "Edward Norton")
        #expect(result.originalName == nil)
        #expect(result.character == "The Narrator")
        #expect(result.knownForDepartment == nil)
        #expect(result.gender == .male)
        #expect(result.profilePath == nil)
        #expect(result.popularity == nil)
        #expect(result.order == 0)
        #expect(result.isAdultOnly == nil)
    }

    private let castMember = CastMember(
        id: 819,
        castID: 4,
        creditID: "52fe4250c3a36847f80149f3",
        name: "Edward Norton",
        originalName: "Edward Harrison Norton",
        character: "The Narrator",
        knownForDepartment: "Acting",
        gender: .male,
        profilePath: URL(string: "/eIkFHNlfretLS1spAcIoihKUS62.jpg"),
        popularity: 25.286,
        order: 0,
        isAdultOnly: false
    )

}
