//
//  CrewMember+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension CrewMember {

    static func mock(
        id: Int = 1,
        creditID: String = "2",
        name: String = "Crew Name",
        job: String = "Job Name",
        department: String = "Department Name",
        gender: Gender? = Gender.male,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")
    ) -> CrewMember {
        CrewMember(
            id: id,
            creditID: creditID,
            name: name,
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
