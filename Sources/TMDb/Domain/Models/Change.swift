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

///
/// A type-erased codable value container.
///
/// Use this type when the value type is not known at compile time, such as with dynamic JSON responses.
///
public struct AnyCodable: Codable, Equatable, Hashable, Sendable {

    ///
    /// The underlying value.
    ///
    public let value: (any Codable & Sendable)?

    ///
    /// Creates an any codable object.
    ///
    /// - Parameter value: The underlying value.
    ///
    public init(_ value: (any Codable & Sendable)?) {
        self.value = value
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = nil
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary
        } else {
            self.value = nil
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let value as Bool:
            try container.encode(value)
        case let value as Int:
            try container.encode(value)
        case let value as Double:
            try container.encode(value)
        case let value as String:
            try container.encode(value)
        case let value as [AnyCodable]:
            try container.encode(value)
        case let value as [String: AnyCodable]:
            try container.encode(value)
        default:
            try container.encodeNil()
        }
    }

    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case (.none, .none):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [AnyCodable], rhs as [AnyCodable]):
            return lhs == rhs
        case let (lhs as [String: AnyCodable], rhs as [String: AnyCodable]):
            return lhs == rhs
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch value {
        case let value as Bool:
            hasher.combine(value)
        case let value as Int:
            hasher.combine(value)
        case let value as Double:
            hasher.combine(value)
        case let value as String:
            hasher.combine(value)
        case let value as [AnyCodable]:
            hasher.combine(value)
        case let value as [String: AnyCodable]:
            for (key, val) in value.sorted(by: { $0.key < $1.key }) {
                hasher.combine(key)
                hasher.combine(val)
            }
        default:
            break
        }
    }

}
