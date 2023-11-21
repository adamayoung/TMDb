//
//  Certifications+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
@testable import TMDb

extension Certifications {

    static func mock(
        certifications: [String: [Certification]] = ["GB": [.gbU, .gbPG]]
    ) -> Self {
        .init(
            certifications: certifications
        )
    }

    static var gbAndUS: Self {
        .mock(
            certifications: [
                "GB": [.gbU, .gbPG, .gb12A],
                "US": [.usG, .usPG13]
            ]
        )
    }

}
