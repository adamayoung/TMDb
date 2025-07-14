//
//  PersonListItem.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

///
/// A model representing a person.
///
public struct PersonListItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Person's name.
    ///
    public let name: String

    ///
    /// Person's original name.
    ///
    public let originalName: String

    ///
    /// Department this person is known for.
    ///
    public let knownForDepartment: String?

    ///
    /// Person's gender.
    ///
    public let gender: Gender

    ///
    /// Person's profile path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Person's current popularity.
    ///
    public let popularity: Double?

    ///
    /// Person's movies and TV series they're known for.
    ///
    public let knownFor: [Show]?

    ///
    /// Is the Person only suitable for adults.
    ///
    public let isAdultOnly: Bool

    ///
    /// Creates a person object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - name: Person's name.
    ///    - originalName: Person's original name.
    ///    - knownForDepartment: Department this person is known for.
    ///    - gender: Person's gender.
    ///    - profilePath: Person's profile path.
    ///    - popularity: Person's current popularity.
    ///    - knownFor: Person's movies and TV series they're known for.
    ///    - isAdultOnly: Is the Person only suitable for adults.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String,
        knownForDepartment: String? = nil,
        gender: Gender,
        profilePath: URL? = nil,
        popularity: Double? = nil,
        knownFor: [Show]? = nil,
        isAdultOnly: Bool = false
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.knownForDepartment = knownForDepartment
        self.gender = gender
        self.profilePath = profilePath
        self.popularity = popularity
        self.knownFor = knownFor
        self.isAdultOnly = isAdultOnly
    }

}

extension PersonListItem {

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case knownForDepartment
        case gender
        case profilePath
        case popularity
        case knownFor
        case isAdultOnly = "adult"
    }

}
