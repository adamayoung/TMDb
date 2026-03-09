//
//  CrewMemberTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CrewMemberTests {

    @Test("JSON decoding of CrewMember", .tags(.decoding))
    func decodeCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CrewMember.self, fromResource: "crew-member"
        )

        #expect(result.id == crewMember.id)
        #expect(result.creditID == crewMember.creditID)
        #expect(result.name == crewMember.name)
        #expect(result.originalName == crewMember.originalName)
        #expect(result.job == crewMember.job)
        #expect(result.department == crewMember.department)
        #expect(result.knownForDepartment == crewMember.knownForDepartment)
        #expect(result.gender == crewMember.gender)
        #expect(result.profilePath == crewMember.profilePath)
        #expect(result.popularity == crewMember.popularity)
        #expect(result.isAdultOnly == crewMember.isAdultOnly)
    }

    @Test(
        "JSON decoding of CrewMember without optional fields",
        .tags(.decoding)
    )
    func decodeCrewMemberWithoutOptionalFields() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CrewMember.self,
            fromResource: "crew-member-without-optional-fields"
        )

        #expect(result.id == 1254)
        #expect(result.creditID == "52fe4250c3a36847f8014a11")
        #expect(result.name == "Art Linson")
        #expect(result.originalName == nil)
        #expect(result.job == "Producer")
        #expect(result.department == "Production")
        #expect(result.knownForDepartment == nil)
        #expect(result.gender == .unknown)
        #expect(result.profilePath == nil)
        #expect(result.popularity == nil)
        #expect(result.isAdultOnly == nil)
    }

    private let crewMember = CrewMember(
        id: 1254,
        creditID: "52fe4250c3a36847f8014a11",
        name: "Art Linson",
        originalName: "Art Linson",
        job: "Producer",
        department: "Production",
        knownForDepartment: "Production",
        gender: .unknown,
        profilePath: URL(string: "/dEtVivCXxQBtIzmJcUNupT1AB4H.jpg"),
        popularity: 3.518,
        isAdultOnly: false
    )

}
