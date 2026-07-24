//
//  ShowWatchProviderResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// NOTE: This file is duplicated at
// Tests/TMDbIntelligenceTests/Mocks/ShowWatchProviderResult+Mocks.swift.
// It mocks an *internal* TMDb type, so it needs @testable import TMDb and
// cannot live in the shared TMDbTestFixtures target (whose declarations are
// `package` and must not expose internal types). Keep both copies in sync.

import Foundation
@testable import TMDb

extension ShowWatchProviderResult {

    static func mock(
        id: Int = 1,
        regionCode: String = "GB"
    ) -> ShowWatchProviderResult {
        ShowWatchProviderResult(
            id: id,
            results: [regionCode: .mock()]
        )
    }

}
