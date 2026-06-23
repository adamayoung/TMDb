//
//  AccountStates+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension AccountStates {

    /// A sample `AccountStates` for use in tests and previews.
    static var sample: AccountStates {
        AccountStates(
            id: 1,
            favorite: false,
            rated: AccountStates.RatedValue(value: 8.5),
            watchlist: false
        )
    }

}
