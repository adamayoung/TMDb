//
//  PersonListItem+Mocks.swift
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

extension PersonListItem {

    static func mock(
        id: Int = .randomID,
        name: String = .random,
        originalName: String,
        knownForDepartment: String? = .random,
        gender: Gender = .unknown,
        profilePath: URL? = .randomImagePath,
        popularity: Double? = Double.random(in: 1...10)
    ) -> Self {
        .init(
            id: id,
            name: name,
            originalName: originalName,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath,
            popularity: popularity
        )
    }

    static var tomCruise: Self {
        .mock(id: 500, name: "Tom Cruise", originalName: "Tom Cruise")
    }

    static var bradPitt: Self {
        .mock(id: 287, name: "Brad Pitt", originalName: "Brad Pitt")
    }

    static var johnnyDepp: Self {
        .mock(id: 85, name: "Johnny Depp", originalName: "Johnny Depp")
    }

    static var quentinTarantino: Self {
        .mock(id: 138, name: "Quentin Tarantino", originalName: "Quentin Tarantino")
    }

}

extension [PersonListItem] {

    static var mocks: [Element] {
        [
            .tomCruise,
            .bradPitt,
            .johnnyDepp,
            .quentinTarantino,
        ]
    }

}
