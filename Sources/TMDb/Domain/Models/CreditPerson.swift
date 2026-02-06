//
//  CreditPerson.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a person in a credit response.
///
public struct CreditPerson: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Person name.
    ///
    public let name: String

    ///
    /// Person original name.
    ///
    public let originalName: String?

    ///
    /// Person gender.
    ///
    public let gender: Gender?

    ///
    /// Person known for department.
    ///
    public let knownForDepartment: String?

    ///
    /// Person profile image path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Person popularity.
    ///
    public let popularity: Double?

    ///
    /// Creates a credit person object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - name: Person name.
    ///    - originalName: Person original name.
    ///    - gender: Person gender.
    ///    - knownForDepartment: Person known for department.
    ///    - profilePath: Person profile image path.
    ///    - popularity: Person popularity.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String? = nil,
        gender: Gender? = nil,
        knownForDepartment: String? = nil,
        profilePath: URL? = nil,
        popularity: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.profilePath = profilePath
        self.popularity = popularity
    }

}
