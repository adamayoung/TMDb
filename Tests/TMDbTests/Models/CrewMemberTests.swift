//
//  CrewMemberTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class CrewMemberTests: XCTestCase {

    func testDecodeReturnsCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(CrewMember.self, fromResource: "crew-member")

        XCTAssertEqual(result.id, crewMember.id)
        XCTAssertEqual(result.creditID, crewMember.creditID)
        XCTAssertEqual(result.name, crewMember.name)
        XCTAssertEqual(result.job, crewMember.job)
        XCTAssertEqual(result.department, crewMember.department)
        XCTAssertEqual(result.gender, crewMember.gender)
        XCTAssertEqual(result.profilePath, crewMember.profilePath)
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
