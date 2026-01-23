//
//  ShowWatchProvider+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension ShowWatchProvider {

    static func mock(
        link: String = "",
        free: [WatchProvider]? = [.netflix],
        flatRate: [WatchProvider]? = [.netflix],
        buy: [WatchProvider]? = [.netflix],
        rent: [WatchProvider]? = [.netflix]
    ) -> ShowWatchProvider {
        ShowWatchProvider(
            link: link,
            free: free,
            flatRate: flatRate,
            buy: buy,
            rent: rent
        )
    }
}
