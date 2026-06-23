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
            id: 550,
            cast: [
                CastMember(
                    id: 819,
                    castID: 4,
                    creditID: "52fe4250c3a36847f80149f3",
                    name: "Edward Norton",
                    originalName: "Edward Norton",
                    character: "Narrator",
                    knownForDepartment: "Acting",
                    gender: .male,
                    profilePath: URL(string: "/8nytsqL59SFJTVYVrN72k6qkGgJ.jpg"),
                    popularity: 3.9038,
                    order: 0,
                    isAdultOnly: false
                )
            ],
            crew: [
                CrewMember(
                    id: 7467,
                    creditID: "631f0289568463007bbe28a5",
                    name: "David Fincher",
                    originalName: "David Fincher",
                    job: "Director",
                    department: "Directing",
                    knownForDepartment: "Directing",
                    gender: .male,
                    profilePath: URL(string: "/tpEczFclQZeKAiCeKZZ0adRvtfz.jpg"),
                    popularity: 2.4671,
                    isAdultOnly: false
                )
            ]
        )
    }

}
