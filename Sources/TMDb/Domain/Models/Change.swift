//
//  Change.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a change to a media item.
///
public struct Change: Codable, Equatable, Hashable, Sendable {

    ///
    /// The key identifying what was changed.
    ///
    /// Examples include "title", "overview", "cast", etc.
    ///
    public let key: String

    ///
    /// The list of individual change items.
    ///
    public let items: [ChangeItem]

    ///
    /// Creates a change object.
    ///
    /// - Parameters:
    ///    - key: The key identifying what was changed.
    ///    - items: The list of individual change items.
    ///
    public init(key: String, items: [ChangeItem]) {
        self.key = key
        self.items = items
    }

}

///
/// A model representing a single change item.
///
public struct ChangeItem: Codable, Equatable, Hashable, Sendable {

    ///
    /// The unique identifier for this change item.
    ///
    public let id: String

    ///
    /// The action performed.
    ///
    /// Examples include "added", "updated", "deleted", etc.
    ///
    public let action: String

    ///
    /// The time when the change was made.
    ///
    public let time: Date

    ///
    /// The ISO 639-1 language code, if applicable.
    ///
    public let languageCode: String?

    ///
    /// The ISO 3166-1 country code, if applicable.
    ///
    public let countryCode: String?

    ///
    /// The new value after the change.
    ///
    public let value: AnyCodable?

    ///
    /// The original value before the change.
    ///
    public let originalValue: AnyCodable?

    ///
    /// Creates a change item object.
    ///
    /// - Parameters:
    ///    - id: The unique identifier for this change item.
    ///    - action: The action performed.
    ///    - time: The time when the change was made.
    ///    - languageCode: The ISO 639-1 language code, if applicable.
    ///    - countryCode: The ISO 3166-1 country code, if applicable.
    ///    - value: The new value after the change.
    ///    - originalValue: The original value before the change.
    ///
    public init(
        id: String,
        action: String,
        time: Date,
        languageCode: String? = nil,
        countryCode: String? = nil,
        value: AnyCodable? = nil,
        originalValue: AnyCodable? = nil
    ) {
        self.id = id
        self.action = action
        self.time = time
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.value = value
        self.originalValue = originalValue
    }

}

extension ChangeItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case action
        case time
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case value
        case originalValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.action = try container.decode(String.self, forKey: .action)
        self.languageCode = try container.decodeIfPresent(String.self, forKey: .languageCode)
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.value = try container.decodeIfPresent(AnyCodable.self, forKey: .value)
        self.originalValue = try container.decodeIfPresent(AnyCodable.self, forKey: .originalValue)

        // Decode time using the auth date formatter
        let timeString = try container.decode(String.self, forKey: .time)
        let dateFormatter = DateFormatter.theMovieDatabaseAuth
        guard let date = dateFormatter.date(from: timeString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .time,
                in: container,
                debugDescription: "Date string '\(timeString)' does not match expected format '\(dateFormatter.dateFormat ?? "")'"
            )
        }
        self.time = date
    }

}

///
/// A model representing a collection of changes.
///
public struct ChangeCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// The list of changes.
    ///
    public let changes: [Change]

    ///
    /// Creates a change collection object.
    ///
    /// - Parameter changes: The list of changes.
    ///
    public init(changes: [Change]) {
        self.changes = changes
    }

}

///
/// A model representing a media item that has changed.
///
public struct ChangedID: Codable, Equatable, Hashable, Sendable {

    ///
    /// The media item identifier.
    ///
    public let id: Int

    ///
    /// Indicates if the media item is adult content.
    ///
    public let adult: Bool?

    ///
    /// Creates a changed ID object.
    ///
    /// - Parameters:
    ///    - id: The media item identifier.
    ///    - adult: Indicates if the media item is adult content.
    ///
    public init(id: Int, adult: Bool? = nil) {
        self.id = id
        self.adult = adult
    }

}

///
/// A model representing a pageable collection of changed media items.
///
public struct ChangedIDCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// The list of changed media items.
    ///
    public let results: [ChangedID]

    ///
    /// The current page number.
    ///
    public let page: Int

    ///
    /// The total number of pages.
    ///
    public let totalPages: Int

    ///
    /// The total number of results.
    ///
    public let totalResults: Int

    ///
    /// Creates a changed ID collection object.
    ///
    /// - Parameters:
    ///    - results: The list of changed media items.
    ///    - page: The current page number.
    ///    - totalPages: The total number of pages.
    ///    - totalResults: The total number of results.
    ///
    public init(results: [ChangedID], page: Int, totalPages: Int, totalResults: Int) {
        self.results = results
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }

}
