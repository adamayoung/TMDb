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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct CrewMemberTests {

    @Test("JSON decoding of Country", .tags(.decoding))
    func decodeCrewMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(CrewMember.self, fromResource: "crew-member")

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
