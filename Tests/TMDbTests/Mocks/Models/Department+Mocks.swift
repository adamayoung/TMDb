//
//  Department+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Department {

    static func mock(
        name: String = "Costume & Make-Up",
        jobs: [String] = ["Set Costumer", "Co-Costume Designer"]
    ) -> Department {
        Department(
            name: name,
            jobs: jobs
        )
    }

    static var costumeAndMakeUp: Department {
        Department.mock(
            name: "Costume & Make-Up",
            jobs: [
                "Set Costumer",
                "Co-Costume Designer"
            ]
        )
    }

    static var production: Department {
        Department.mock(
            name: "Production",
            jobs: [
                "Casting",
                "ADR Voice Casting",
                "Production Accountant"
            ]
        )
    }

}

extension [Department] {

    static var mocks: [Department] {
        [.costumeAndMakeUp, .production]
    }

}
