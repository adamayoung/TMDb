//
//  Creator+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

extension Creator {

    static func mock(
        id: Int = 1,
        creditID: String = "credit1",
        name: String = "Creator Name",
        originalName: String = "Original Creator Name",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/creator.jpg")
    ) -> Self {
        .init(
            id: id,
            creditID: creditID,
            name: name,
            originalName: originalName,
            gender: gender,
            profilePath: profilePath
        )
    }

}
