//
//  PersonListItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
    public let isAdultOnly: Bool?

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
        isAdultOnly: Bool? = nil
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

    private enum CodingKeys: String, CodingKey {
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

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested
    /// type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.knownForDepartment = try container.decodeIfPresent(
            String.self, forKey: .knownForDepartment
        )
        self.gender = (try? container.decodeIfPresent(Gender.self, forKey: .gender)) ?? .unknown
        self.profilePath = try container.decodeIfPresent(URL.self, forKey: .profilePath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.knownFor = try container.decodeIfPresent([Show].self, forKey: .knownFor)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)
    }

}
