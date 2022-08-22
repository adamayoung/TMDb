import Foundation
import TMDb

extension CastMember {

    static func mock(
        id: Int = .randomID,
        castID: Int? = .randomID,
        creditID: String = .randomID,
        name: String? = .randomString,
        character: String? = .randomString,
        gender: Gender? = .male,
        profilePath: URL? = .randomImagePath,
        order: Int = Int.random(in: 1...10)
    ) -> Self {
        .init(
            id: id,
            castID: castID,
            creditID: creditID,
            name: name ?? "Cast \(id)",
            character: name ?? "Character \(id)",
            gender: gender,
            profilePath: profilePath,
            order: order
        )
    }

    static var chrisHemsworth: Self {
        .mock(
            id: 74568,
            castID: 85,
            creditID: "62c8c25290b87e00f53973fb",
            name: "Chris Hemsworth",
            character: "Thor Odinson",
            gender: Gender.male,
            profilePath: URL(string: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg")!,
            order: 0
        )
    }

    static var christianBale: Self {
        .mock(
            id: 3894,
            castID: 87,
            creditID: "62c8c27f3d4d96004c9f1996",
            name: "Christian Bale",
            character: "Gorr",
            gender: Gender.male,
            profilePath: URL(string: "/qCpZn2e3dimwbryLnqxZuI88PTi.jpg")!,
            order: 1
        )
    }

}

extension Array where Element == CastMember {

    static var mocks: [Element] {
        [
            .chrisHemsworth,
            .christianBale
        ]
    }

}
