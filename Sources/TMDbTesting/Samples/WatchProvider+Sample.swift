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
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
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
