//
//  Certifications+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@testable import TMDb

extension Certifications {

    static func mock(
        certifications: [String: [Certification]] = ["GB": [.gbU, .gbPG]]
    ) -> Certifications {
        Certifications(
            certifications: certifications
        )
    }

    static var gbAndUS: Certifications {
        Certifications.mock(
            certifications: [
                "GB": [.gbU, .gbPG, .gb12A],
                "US": [.usG, .usPG13]
            ]
        )
    }

}
