import Foundation
import TMDb

extension Department {

    static func mock(
        name: String = .randomString,
        jobs: [String] = [.randomString, .randomString]
    ) -> Self {
        .init(
            name: name,
            jobs: jobs
        )
    }

    static var costumeAndMakeUp: Self {
        .mock(
            name: "Costume & Make-Up",
            jobs: [
                "Set Costumer",
                "Co-Costume Designer"
            ]
        )
    }

    static var production: Self {
        .mock(
            name: "Production",
            jobs: [
                "Casting",
                "ADR Voice Casting",
                "Production Accountant"
            ]
        )
    }

}

extension Array where Element == Department {

    static var mocks: [Department] {
        [.costumeAndMakeUp, .production]
    }

}
