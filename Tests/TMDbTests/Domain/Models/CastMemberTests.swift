//
//  CastMemberTests.swift
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

@Suite
struct CastMemberTests {

    @Test("JSON decoding of APIConfiguration", .tags(.decoding))
    func testDecodeReturnsCastMember() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(CastMember.self, fromResource: "cast-member")

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
