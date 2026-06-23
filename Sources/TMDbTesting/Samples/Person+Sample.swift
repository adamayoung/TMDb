//
//  Person+Sample.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

public extension Person {

    /// A sample `Person` for use in previews and tests.
    static var sample: Person {
        Person(
            id: 500,
            name: "Tom Cruise",
            alsoKnownAs: ["Tom Cruise"],
            birthday: Date(timeIntervalSince1970: 1_384_510_800),
            gender: .male,
            profilePath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
            popularity: 6.8,
            homepageURL: URL(string: "https://www.person.com"),
            isAdultOnly: false
        )
    }

}
