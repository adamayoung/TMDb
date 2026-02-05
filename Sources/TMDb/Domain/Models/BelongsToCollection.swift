//
//  BelongsToCollection.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a movie's collection membership.
///
public struct BelongsToCollection: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Collection name.
    ///
    public let name: String

    ///
    /// Collection poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Collection backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// Creates a belongs to collection object.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - name: Collection name.
    ///    - posterPath: Collection poster path.
    ///    - backdropPath: Collection backdrop path.
    ///
    public init(
        id: Int,
        name: String,
        posterPath: URL? = nil,
        backdropPath: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }

}
