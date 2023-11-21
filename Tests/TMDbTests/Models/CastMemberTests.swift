//
//  CastMemberTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class CastMemberTests: XCTestCase {

    func testDecodeReturnsCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(CastMember.self, fromResource: "cast-member")

        XCTAssertEqual(result.id, castMember.id)
        XCTAssertEqual(result.castID, castMember.castID)
        XCTAssertEqual(result.creditID, castMember.creditID)
        XCTAssertEqual(result.name, castMember.name)
        XCTAssertEqual(result.character, castMember.character)
        XCTAssertEqual(result.gender, castMember.gender)
        XCTAssertEqual(result.profilePath, castMember.profilePath)
        XCTAssertEqual(result.order, castMember.order)
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
