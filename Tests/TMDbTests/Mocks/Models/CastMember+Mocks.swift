//
//  CastMember+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CastMember {

    static func mock(
        id: Int = 1,
        castID: Int? = 2,
        creditID: String = "3",
        name: String = "Actor Name",
        character: String = "Character Name",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        order: Int = 1
    ) -> CastMember {
        CastMember(
            id: id,
            castID: castID,
            creditID: creditID,
            name: name,
            character: character,
            gender: gender,
            profilePath: profilePath,
            order: order
        )
    }

    static var chrisHemsworth: CastMember {
        CastMember.mock(
            id: 74568,
            castID: 85,
            creditID: "62c8c25290b87e00f53973fb",
            name: "Chris Hemsworth",
            character: "Thor Odinson",
            gender: Gender.male,
            profilePath: URL(string: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg"),
            order: 0
        )
    }

    static var christianBale: CastMember {
        CastMember.mock(
            id: 3894,
            castID: 87,
            creditID: "62c8c27f3d4d96004c9f1996",
            name: "Christian Bale",
            character: "Gorr",
            gender: Gender.male,
            profilePath: URL(string: "/qCpZn2e3dimwbryLnqxZuI88PTi.jpg"),
            order: 1
        )
    }

}

extension [CastMember] {

    static var mocks: [Element] {
        [
            .chrisHemsworth,
            .christianBale
        ]
    }

}
