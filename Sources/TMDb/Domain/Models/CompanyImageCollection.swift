//
//  CompanyImageCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a collection of images for a company.
///
public struct CompanyImageCollection: Identifiable, Codable, Equatable,
Hashable, Sendable {

    ///
    /// Company identifier.
    ///
    public let id: Int

    ///
    /// Company logos.
    ///
    public let logos: [ImageMetadata]

    ///
    /// Creates a company image collection object.
    ///
    /// - Parameters:
    ///   - id: Company identifier.
    ///   - logos: Company logos.
    ///
    public init(id: Int, logos: [ImageMetadata]) {
        self.id = id
        self.logos = logos
    }

}
