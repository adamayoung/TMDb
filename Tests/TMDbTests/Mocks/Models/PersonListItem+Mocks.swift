//
//  PersonListItem+Mocks.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

extension PersonListItem {

    static func mock(
        id: Int = 1,
        name: String = "Person Name",
        originalName: String,
        knownForDepartment: String? = nil,
        gender: Gender = .unknown,
        profilePath: URL? = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg"),
        popularity: Double? = nil,
        knownFor: [Show]? = nil,
        isAdultOnly: Bool? = nil
    ) -> PersonListItem {
        PersonListItem(
            id: id,
            name: name,
            originalName: originalName,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath,
            popularity: popularity,
            knownFor: knownFor,
            isAdultOnly: isAdultOnly
        )
    }

    static var tomCruise: PersonListItem {
        PersonListItem.mock(id: 500, name: "Tom Cruise", originalName: "Tom Cruise")
    }

    static var bradPitt: PersonListItem {
        PersonListItem.mock(
            id: 287,
            name: "Brad Pitt",
            originalName: "Brad Pitt",
            gender: .male,
            isAdultOnly: false
        )
    }

    static var johnnyDepp: PersonListItem {
        PersonListItem.mock(id: 85, name: "Johnny Depp", originalName: "Johnny Depp")
    }

    static var quentinTarantino: PersonListItem {
        PersonListItem.mock(id: 138, name: "Quentin Tarantino", originalName: "Quentin Tarantino")
    }

}

extension [PersonListItem] {

    static var mocks: [PersonListItem] {
        [
            .tomCruise,
            .bradPitt,
            .johnnyDepp,
            .quentinTarantino
        ]
    }

}
