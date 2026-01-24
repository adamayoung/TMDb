//
//  Creator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a creator of a TV series.
///
public struct Creator: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Creator's identifier.
    ///
    public let id: Int

    ///
    /// Creator's identifier for the particular TV series.
    ///
    public let creditID: String

    ///
    /// Creator's name.
    ///
    public let name: String

    ///
    /// Creator's original name.
    ///
    public let originalName: String

    ///
    /// Creator's gender.
    ///
    public let gender: Gender

    ///
    /// Creator's profile image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let profilePath: URL?

    ///
    /// Creates a creator object.
    ///
    /// - Parameters:
    ///    - id: Creator's identifier.
    ///    - creditID: Creator's identifier for the particular TV series.
    ///    - name: Creator's name.
    ///    - originalName: Creator's original name.
    ///    - gender: Creator's gender.
    ///    - profilePath: Creator's profile image.
    ///
    public init(
        id: Int,
        creditID: String,
        name: String,
        originalName: String,
        gender: Gender = .unknown,
        profilePath: URL? = nil
    ) {
        self.id = id
        self.creditID = creditID
        self.name = name
        self.originalName = originalName
        self.gender = gender
        self.profilePath = profilePath
    }

}

extension Creator {

    private enum CodingKeys: String, CodingKey {
        case id
        case creditID = "creditId"
        case name
        case originalName
        case gender
        case profilePath
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.creditID = try container.decode(String.self, forKey: .creditID)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.gender = (try? container.decodeIfPresent(Gender.self, forKey: .gender)) ?? .unknown
        self.profilePath = try container.decodeIfPresent(URL.self, forKey: .profilePath)
    }

}
