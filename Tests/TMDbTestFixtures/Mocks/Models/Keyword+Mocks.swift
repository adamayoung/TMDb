//
//  Keyword+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

package extension Keyword {

    static func mock(
        id: Int = 378,
        name: String = "prison"
    ) -> Keyword {
        Keyword(
            id: id,
            name: name
        )
    }

    static var prison: Keyword {
        Keyword.mock(
            id: 378,
            name: "prison"
        )
    }

}
