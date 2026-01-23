//
//  ShowWatchProvidersByCountry+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension ShowWatchProvidersByCountry {

    static func mock(
        countryCode: String = "US",
        watchProviders: ShowWatchProvider = .mock()
    ) -> ShowWatchProvidersByCountry {
        ShowWatchProvidersByCountry(
            countryCode: countryCode,
            watchProviders: watchProviders
        )
    }

}
