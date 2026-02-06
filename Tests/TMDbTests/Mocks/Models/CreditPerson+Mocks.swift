//
//  CreditPerson+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CreditPerson {

    static func mock(
        id: Int = 17419,
        name: String = "Bryan Cranston",
        originalName: String? = "Bryan Cranston",
        gender: Gender? = .male,
        knownForDepartment: String? = "Acting",
        profilePath: URL? = URL(
            string: "/npIIZJGSrcJIJ6yHdmbqO6Jzo5I.jpg"
        ),
        popularity: Double? = 7.1326
    ) -> CreditPerson {
        CreditPerson(
            id: id,
            name: name,
            originalName: originalName,
            gender: gender,
            knownForDepartment: knownForDepartment,
            profilePath: profilePath,
            popularity: popularity
        )
    }

    static var bryanCranston: CreditPerson {
        CreditPerson.mock()
    }

}
