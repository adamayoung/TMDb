//
//  Network.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TV network.
///
public struct Network: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Network identifier.
    ///
    public let id: Int

    ///
    /// Network name.
    ///
    public let name: String

    ///
    /// Network logo path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let logoPath: URL?

    ///
    /// Network origin country.
    ///
    public let originCountry: String?

    ///
    /// Network headquarters location.
    ///
    public let headquarters: String?

    ///
    /// Network homepage URL.
    ///
    public let homepage: URL?

    ///
    /// Creates a network object.
    ///
    /// - Parameters:
    ///    - id: Network identifier.
    ///    - name: Network name.
    ///    - logoPath: Network logo path.
    ///    - originCountry: Network origin country.
    ///    - headquarters: Network headquarters location.
    ///    - homepage: Network homepage URL.
    ///
    public init(
        id: Int,
        name: String,
        logoPath: URL? = nil,
        originCountry: String? = nil,
        headquarters: String? = nil,
        homepage: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
        self.originCountry = originCountry
        self.headquarters = headquarters
        self.homepage = homepage
    }

}

extension Network {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath
        case originCountry
        case headquarters
        case homepage
    }

    ///
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
    ///
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.logoPath = try container.decodeIfPresent(URL.self, forKey: .logoPath)
        self.originCountry = try container.decodeIfPresent(String.self, forKey: .originCountry)
        self.headquarters = try container.decodeIfPresent(String.self, forKey: .headquarters)
        self.homepage = try container.decodeNonEmptyURLIfPresent(forKey: .homepage)
    }

}
