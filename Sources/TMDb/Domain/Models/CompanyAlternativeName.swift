//
//  CompanyAlternativeName.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an alternative name for a company.
///
public struct CompanyAlternativeName: Codable, Equatable, Hashable, Sendable {

    ///
    /// Alternative name of the company.
    ///
    public let name: String

    ///
    /// Type of the alternative name.
    ///
    public let type: String

    ///
    /// Creates a company alternative name object.
    ///
    /// - Parameters:
    ///   - name: Alternative name of the company.
    ///   - type: Type of the alternative name.
    ///
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }

}
