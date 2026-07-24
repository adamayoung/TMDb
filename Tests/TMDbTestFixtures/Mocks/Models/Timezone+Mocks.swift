//
//  Timezone+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension Timezone {

    static func mock(
        iso31661: String = "US",
        zones: [String] = ["America/New_York", "America/Los_Angeles"]
    ) -> Timezone {
        Timezone(
            iso31661: iso31661,
            zones: zones
        )
    }

}

package extension [Timezone] {

    static var mocks: [Element] {
        [.mock(), .mock(iso31661: "GB", zones: ["Europe/London"])]
    }

}
