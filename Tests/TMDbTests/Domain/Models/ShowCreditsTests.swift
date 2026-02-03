//
//  ShowCreditsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct ShowCreditsTests {

    @Test("JSON decoding of ShowCredits", .tags(.decoding))
    func decodeReturnsShowCredits() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ShowCredits.self, fromResource: "show-credits"
        )

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
