//
//  ShowCredits+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension ShowCredits {

    /// A sample `ShowCredits` for use in tests and previews.
    static var sample: ShowCredits {
        ShowCredits(
            id: 1,
            cast: [
                CastMember(
                    id: 74568,
                    castID: 85,
                    creditID: "62c8c25290b87e00f53973fb",
                    name: "Chris Hemsworth",
                    originalName: "Chris Hemsworth",
                    character: "Thor Odinson",
                    knownForDepartment: "Acting",
                    gender: .male,
                    profilePath: URL(string: "/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg"),
                    popularity: 10.5,
                    order: 0,
                    isAdultOnly: false
                )
            ],
            crew: [
                CrewMember(
                    id: 1,
                    creditID: "2",
                    name: "Crew Name",
                    originalName: "Crew Original Name",
                    job: "Job Name",
                    department: "Department Name",
                    knownForDepartment: "Department Name",
                    gender: .male,
                    profilePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
                    popularity: 5.2,
                    isAdultOnly: false
                )
            ]
        )
    }

}
