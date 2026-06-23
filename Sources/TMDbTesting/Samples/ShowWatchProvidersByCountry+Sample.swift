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
        let amazonVideo = WatchProvider(
            id: 10,
            name: "Amazon Video",
            logoPath: URL(string: "/qR6FKvnPBx2O37FDg8PNM7efwF3.jpg"),
            displayPriority: 7
        )

        return ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: ShowWatchProvider(
                link: nil,
                free: [amazonVideo],
                flatRate: [amazonVideo],
                buy: [amazonVideo],
                rent: [amazonVideo],
                ads: [amazonVideo]
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
