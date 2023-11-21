//
//  CrewMember+Mocks.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation
import TMDb

extension CrewMember {

    static func mock(
        id: Int = .randomID,
        creditID: String = .randomID,
        name: String? = nil,
        job: String = "Job \(String.randomString)",
        department: String = "Department \(String.randomString))",
        gender: Gender? = Gender.male,
        profilePath: URL? = .randomImagePath
    ) -> Self {
        .init(
            id: id,
            creditID: creditID,
            name: name ?? "Crew Member \(id)",
            job: job,
            department: department,
            gender: gender,
            profilePath: profilePath
        )
    }

}

extension [CrewMember] {

    static var mocks: [Element] {
        []
    }

}
