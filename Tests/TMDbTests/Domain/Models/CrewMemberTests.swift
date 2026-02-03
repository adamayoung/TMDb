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

    @Test("JSON decoding of Country", .tags(.decoding))
    func decodeCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CrewMember.self, fromResource: "crew-member"
        )

        #expect(result.id == crewMember.id)
        #expect(result.creditID == crewMember.creditID)
        #expect(result.name == crewMember.name)
        #expect(result.job == crewMember.job)
        #expect(result.department == crewMember.department)
        #expect(result.gender == crewMember.gender)
        #expect(result.profilePath == crewMember.profilePath)
    }

    private let crewMember = CrewMember(
        id: 1254,
        creditID: "52fe4250c3a36847f8014a11",
        name: "Art Linson",
        job: "Producer",
        department: "Production",
        gender: .unknown,
        profilePath: URL(string: "/dEtVivCXxQBtIzmJcUNupT1AB4H.jpg")
    )

}
