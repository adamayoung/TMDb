//
//  WatchProvider+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension WatchProvider {

    /// A sample `WatchProvider` populated with representative data.
    static var sample: WatchProvider {
        WatchProvider(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg"),
            displayPriority: 0
        )
    }

}

public extension [WatchProvider] {

    /// A sample array of `WatchProvider` values populated with representative data.
    static var samples: [WatchProvider] {
        [.sample]
    }

}
