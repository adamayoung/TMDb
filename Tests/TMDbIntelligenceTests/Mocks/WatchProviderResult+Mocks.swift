//
//  WatchProviderResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// NOTE: This file is duplicated at
// Tests/TMDbTests/Mocks/Models/WatchProviderResult+Mocks.swift.
// It mocks an *internal* TMDb type, so it needs @testable import TMDb and
// cannot live in the shared TMDbTestFixtures target (whose declarations are
// `package` and must not expose internal types). Keep both copies in sync.

import Foundation
@testable import TMDb

extension WatchProviderResult {

    static var mock: Self {
        .init(
            results: [
                .init(
                    id: 8, name: "Netflix",
                    logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
                ),
                .init(
                    id: 9, name: "Amazon Prime Video",
                    logoPath: URL(string: "/emthp39XA2YScoYL1p0sdbAH2WA.jpg")
                )
            ]
        )
    }

}
