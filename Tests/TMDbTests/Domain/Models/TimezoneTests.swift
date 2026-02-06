//
//  TimezoneTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TimezoneTests {

    @Test("JSON decoding of Timezone", .tags(.decoding))
    func decodeReturnsTimezones() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(
                [Timezone].self,
                fromResource: "configuration-timezones"
            )

        #expect(result.count == 3)
        #expect(result[0].iso31661 == "AD")
        #expect(result[0].zones == ["Europe/Andorra"])
        #expect(result[1].iso31661 == "US")
        #expect(result[1].zones.count == 4)
        #expect(result[2].iso31661 == "GB")
        #expect(result[2].zones == ["Europe/London"])
    }

}
