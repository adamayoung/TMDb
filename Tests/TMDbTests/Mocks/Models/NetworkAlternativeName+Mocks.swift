//
//  NetworkAlternativeName+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension NetworkAlternativeName {

    static func mock(
        name: String = "HBO Network",
        type: String = ""
    ) -> NetworkAlternativeName {
        NetworkAlternativeName(
            name: name,
            type: type
        )
    }

}
