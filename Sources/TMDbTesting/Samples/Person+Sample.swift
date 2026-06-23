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
            id: 287,
            name: "Brad Pitt",
            alsoKnownAs: ["William Bradley Pitt"],
            birthday: Date(timeIntervalSince1970: -190_598_400),
            gender: .male,
            profilePath: URL(string: "/m09Y1YfPPeNYYUSHnnVqahkrC1o.jpg"),
            popularity: 8.7551,
            homepageURL: nil,
            isAdultOnly: false
        )
    }

}
