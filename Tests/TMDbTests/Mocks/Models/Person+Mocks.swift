//
//  Person+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension Person {

    static func mock(
        id: Int = 1,
        name: String = "Person Name",
        alsoKnownAs: [String] = ["Person Name"],
        knownForDepartment: String? = nil,
        biography: String? = nil,
        birthday: Date? = Date(iso8601: "2013-11-15T10:20:00Z"),
        deathday: Date? = nil,
        gender: Gender = .unknown,
        placeOfBirth: String? = nil,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = 6.8,
        imdbID: String? = nil,
        homepageURL: URL? = URL(string: "https://www.person.com")
    ) -> Person {
        Person(
            id: id,
            name: name,
            alsoKnownAs: alsoKnownAs,
            knownForDepartment: knownForDepartment,
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: gender,
            placeOfBirth: placeOfBirth,
            profilePath: profilePath,
            popularity: popularity,
            imdbID: imdbID,
            homepageURL: homepageURL
        )
    }

    static var tomCruise: Person {
        Person.mock(id: 500, name: "Tom Cruise")
    }

    static var bradPitt: Person {
        Person.mock(id: 287, name: "Brad Pitt")
    }

    static var johnnyDepp: Person {
        Person.mock(id: 85, name: "Johnny Depp")
    }

    static var quentinTarantino: Person {
        Person.mock(id: 138, name: "Quentin Tarantino")
    }

}

extension [Person] {

    static var mocks: [Element] {
        [
            .tomCruise,
            .bradPitt,
            .johnnyDepp,
            .quentinTarantino
        ]
    }

}
