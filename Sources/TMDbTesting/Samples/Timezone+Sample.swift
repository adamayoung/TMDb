//
//  Timezone+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Timezone {

    /// A sample `Timezone` for use in previews and tests.
    static var sample: Timezone {
        Timezone(
            iso31661: "US",
            zones: ["America/New_York", "America/Los_Angeles"]
        )
    }

}

public extension [Timezone] {

    /// A collection of sample `Timezone` values for use in previews and tests.
    static var samples: [Timezone] {
        [
            Timezone(
                iso31661: "US",
                zones: ["America/New_York", "America/Los_Angeles"]
            ),
            Timezone(
                iso31661: "GB",
                zones: ["Europe/London"]
            )
        ]
    }

}
