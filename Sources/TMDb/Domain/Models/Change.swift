//
//  Change.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a change entry.
///
public struct Change: Codable, Equatable, Hashable, Sendable {

    ///
    /// The key that was changed.
    ///
    public let key: String

    ///
    /// The list of change items.
    ///
    public let items: [ChangeItem]

    ///
    /// Creates a change object.
    ///
    /// - Parameters:
    ///   - key: The key that was changed.
    ///   - items: The list of change items.
    ///
    public init(key: String, items: [ChangeItem]) {
        self.key = key
        self.items = items
    }

}

///
/// A model representing a change item.
///
public struct ChangeItem: Codable, Equatable, Hashable, Sendable {

    ///
    /// Change identifier.
    ///
    public let id: String

    ///
    /// Action performed.
    ///
    public let action: String

    ///
    /// Time of change.
    ///
    public let time: Date

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String?

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String?

    ///
    /// Original value before change.
    ///
    public let originalValue: ChangeValue?

    ///
    /// Value after change.
    ///
    public let value: ChangeValue?

    ///
    /// Creates a change item object.
    ///
    /// - Parameters:
    ///   - id: Change identifier.
    ///   - action: Action performed.
    ///   - time: Time of change.
    ///   - languageCode: ISO 639-1 language code.
    ///   - countryCode: ISO 3166-1 country code.
    ///   - originalValue: Original value before change.
    ///   - value: Value after change.
    ///
    public init(
        id: String,
        action: String,
        time: Date,
        languageCode: String? = nil,
        countryCode: String? = nil,
        originalValue: ChangeValue? = nil,
        value: ChangeValue? = nil
    ) {
        self.id = id
        self.action = action
        self.time = time
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.originalValue = originalValue
        self.value = value
    }

}

extension ChangeItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case action
        case time
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case originalValue
        case value
    }

}

///
/// A model representing a change value (can be string, number, or object).
///
public enum ChangeValue: Codable, Equatable, Hashable, Sendable {

    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
            return
        }

        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
            return
        }

        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
            return
        }

        throw DecodingError.typeMismatch(
            ChangeValue.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected String, Int, Double, or Bool"
            )
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }

}

///
/// A model representing a collection of changes.
///
public struct ChangeCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// List of changes.
    ///
    public let changes: [Change]

    ///
    /// Creates a change collection object.
    ///
    /// - Parameter changes: List of changes.
    ///
    public init(changes: [Change]) {
        self.changes = changes
    }

}

///
/// A model representing a changed media ID.
///
public struct ChangedID: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Is adult content.
    ///
    public let isAdult: Bool?

    ///
    /// Creates a changed ID object.
    ///
    /// - Parameters:
    ///   - id: Media identifier.
    ///   - isAdult: Is adult content.
    ///
    public init(id: Int, isAdult: Bool? = nil) {
        self.id = id
        self.isAdult = isAdult
    }

}

extension ChangedID {

    private enum CodingKeys: String, CodingKey {
        case id
        case isAdult = "adult"
    }

}

///
/// A model representing a collection of changed IDs.
///
public typealias ChangedIDCollection = PageableListResult<ChangedID>
