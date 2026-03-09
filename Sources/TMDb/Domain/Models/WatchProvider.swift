//
//  WatchProvider.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a watch provider.
///
public struct WatchProvider: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Watch Provider identifier.
    ///
    public let id: Int

    ///
    /// Watch Provider Name.
    ///
    public let name: String

    ///
    /// Watch Provider logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL?

    ///
    /// Display priority for ordering providers.
    ///
    public let displayPriority: Int?

    ///
    /// Creates a watch provider object.
    ///
    /// - Parameters:
    ///    - id: Watch Provider identifier.
    ///    - name: Watch Provider name.
    ///    - logoPath: Watch Provider logo path.
    ///    - displayPriority: Display priority for ordering providers.
    ///
    public init(
        id: Int,
        name: String,
        logoPath: URL? = nil,
        displayPriority: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.displayPriority = displayPriority
    }

}

extension WatchProvider {

    private enum CodingKeys: String, CodingKey {
        case id = "providerId"
        case name = "providerName"
        case logoPath
        case displayPriority
    }

}
