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
        originalName: String? = "Crew Original Name",
        job: String = "Job Name",
        department: String = "Department Name",
        knownForDepartment: String? = "Department Name",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 5.2,
        isAdultOnly: Bool? = false
    ) -> CrewMember {
        CrewMember(
            id: id,
            creditID: creditID,
            name: name,
            originalName: originalName,
            job: job,
            department: department,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath,
            popularity: popularity,
            isAdultOnly: isAdultOnly
        )
    }

}

extension [CrewMember] {

    static var mocks: [Element] {
        []
    }

}
