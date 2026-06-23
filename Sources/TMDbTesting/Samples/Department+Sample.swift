//
//  Department+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Department {

    /// A sample `Department` populated with representative data.
    static var sample: Department {
        Department(
            name: "Costume & Make-Up",
            jobs: ["Set Costumer", "Co-Costume Designer"]
        )
    }

}

public extension [Department] {

    /// A sample array of `Department` values populated with representative data.
    static var samples: [Department] {
        [
            Department(
                name: "Costume & Make-Up",
                jobs: ["Set Costumer", "Co-Costume Designer"]
            ),
            Department(
                name: "Production",
                jobs: ["Casting", "ADR Voice Casting", "Production Accountant"]
            )
        ]
    }

}
