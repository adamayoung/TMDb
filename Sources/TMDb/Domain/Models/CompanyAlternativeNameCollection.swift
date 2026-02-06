//
//  CompanyAlternativeNameCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of alternative names for a company.
///
public struct CompanyAlternativeNameCollection: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// Company identifier.
    ///
    public let id: Int

    ///
    /// Alternative names.
    ///
    public let results: [CompanyAlternativeName]

    ///
    /// Creates a company alternative name collection object.
    ///
    /// - Parameters:
    ///   - id: Company identifier.
    ///   - results: Alternative names.
    ///
    public init(id: Int, results: [CompanyAlternativeName]) {
        self.id = id
        self.results = results
    }

}
