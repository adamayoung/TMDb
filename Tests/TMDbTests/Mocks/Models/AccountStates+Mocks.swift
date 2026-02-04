//
//  AccountStates+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension AccountStates {

    static func mock(
        id: Int = 1,
        favorite: Bool = false,
        rated: RatedValue? = RatedValue(value: 8.5),
        watchlist: Bool = false
    ) -> AccountStates {
        AccountStates(
            id: id,
            favorite: favorite,
            rated: rated,
            watchlist: watchlist
        )
    }

}
