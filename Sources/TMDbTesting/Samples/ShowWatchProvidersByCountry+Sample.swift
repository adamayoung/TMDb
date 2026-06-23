//
//  ShowWatchProvidersByCountry+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ShowWatchProvidersByCountry {

    /// A sample `ShowWatchProvidersByCountry` for use in tests and previews.
    static var sample: ShowWatchProvidersByCountry {
        let netflix = WatchProvider(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            displayPriority: 0
        )

        return ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: ShowWatchProvider(
                link: nil,
                free: [netflix],
                flatRate: [netflix],
                buy: [netflix],
                rent: [netflix],
                ads: [netflix]
            )
        )
    }

}

public extension [ShowWatchProvidersByCountry] {

    /// A sample array of `ShowWatchProvidersByCountry` values for use in tests and previews.
    static var samples: [ShowWatchProvidersByCountry] {
        [.sample]
    }

}
