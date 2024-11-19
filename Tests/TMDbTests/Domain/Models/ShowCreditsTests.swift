//
//  ShowCreditsTests.swift
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
struct ShowCreditsTests {

    @Test("JSON decoding of ShowCredits", .tags(.decoding))
    func decodeReturnsShowCredits() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCredits.self, fromResource: "show-credits")

        #expect(result.id == showCredits.id)
        #expect(result.cast == showCredits.cast)
        #expect(result.crew == showCredits.crew)
    }

    private let showCredits = ShowCredits(
        id: 550,
        cast: [
            CastMember(
                id: 819,
                castID: 4,
                creditID: "52fe4250c3a36847f80149f3",
                name: "Edward Norton",
                character: "The Narrator",
                gender: .male,
                profilePath: URL(string: "/eIkFHNlfretLS1spAcIoihKUS62.jpg"),
                order: 0
            ),
            CastMember(
                id: 287,
                castID: 5,
                creditID: "52fe4250c3a36847f80149f7",
                name: "Brad Pitt",
                character: "Tyler Durden",
                gender: .male,
                profilePath: URL(string: "/kc3M04QQAuZ9woUvH3Ju5T7ZqG5.jpg"),
                order: 1
            ),
            CastMember(
                id: 7470,
                castID: 7,
                creditID: "52fe4250c3a36847f80149ff",
                name: "Meat Loaf",
                character: "Robert 'Bob' Paulson",
                gender: .male,
                profilePath: URL(string: "/43nyfW3TxD3PxDqYB8tyqaKpDBH.jpg"),
                order: 2
            )
        ],
        crew: [
            CrewMember(
                id: 7469,
                creditID: "56380f0cc3a3681b5c0200be",
                name: "Jim Uhls",
                job: "Screenplay",
                department: "Writing",
                gender: .unknown,
                profilePath: nil
            ),
            CrewMember(
                id: 7474,
                creditID: "52fe4250c3a36847f8014a05",
                name: "Ross Grayson Bell",
                job: "Producer",
                department: "Production",
                gender: .unknown,
                profilePath: nil
            )
        ]
    )

}
