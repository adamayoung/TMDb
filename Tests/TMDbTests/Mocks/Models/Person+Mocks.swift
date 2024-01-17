//
//  Person+Mocks.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import TMDb

extension Person {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString,
        alsoKnownAs: [String]? = nil,
        knownForDepartment: String? = .randomString,
        biography: String? = .randomString,
        birthday: Date? = .random,
        deathday: Date? = nil,
        gender: Gender = .unknown,
        placeOfBirth: String? = .randomString,
        profilePath: URL? = .randomImagePath,
        popularity: Double? = Double.random(in: 1 ... 10),
        imdbID: String? = .randomString,
        homepageURL: URL? = .randomWebSite
    ) -> Self {
        .init(
            id: id,
            name: name,
            alsoKnownAs: alsoKnownAs ?? [name],
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

    static var tomCruise: Self {
        .mock(id: 500, name: "Tom Cruise")
    }

    static var bradPitt: Self {
        .mock(id: 287, name: "Brad Pitt")
    }

    static var johnnyDepp: Self {
        .mock(id: 85, name: "Johnny Depp")
    }

    static var quentinTarantino: Self {
        .mock(id: 138, name: "Quentin Tarantino")
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
