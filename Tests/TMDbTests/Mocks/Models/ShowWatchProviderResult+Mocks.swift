//
//  ShowWatchProviderResult+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

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
