//
//  AnyCodable.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A type-erased `Codable` value that can represent any JSON type.
///
public enum AnyCodable: Codable, Equatable, Hashable, Sendable {

    /// A string value.
    case string(String)

    /// An integer value.
    case int(Int)

    /// A double value.
    case double(Double)

    /// A boolean value.
    case bool(Bool)

    /// An array of ``AnyCodable`` values.
    case array([AnyCodable])

    /// A dictionary of string keys to ``AnyCodable`` values.
    case dictionary([String: AnyCodable])

    /// A null value.
    case null

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
        } else if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let arrayValue = try? container.decode([AnyCodable].self) {
            self = .array(arrayValue)
        } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
            self = .dictionary(dictionaryValue)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "AnyCodable cannot decode value"
            )
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
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
        case .array(let value):
            try container.encode(value)
        case .dictionary(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }

}
