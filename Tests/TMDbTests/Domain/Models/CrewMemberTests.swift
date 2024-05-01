//
//  CrewMemberTests.swift
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
