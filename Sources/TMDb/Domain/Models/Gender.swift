//
//  Gender.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// A model representing the gender of a person.
///
public enum Gender: Int, Codable, Equatable, Hashable, Sendable {

    ///
    /// An unknown gender.
    ///
    case unknown = 0

    ///
    /// A female.
    ///
    case female = 1

    ///
    /// A male.
    ///
    case male = 2

    ///
    /// Some other gender.
    ///
    case other = 3

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: ``DecodingError.typeMismatch`` if the encountered encoded value is not convertible to the requested type.
    /// - Throws: ``DecodingError.keyNotFound`` if self does not have an entry for the given key.
    /// - Throws: ``DecodingError.valueNotFound`` if self has a null entry for the given key.
    ///
    public init(from decoder: Decoder) throws {
        self =
            try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
