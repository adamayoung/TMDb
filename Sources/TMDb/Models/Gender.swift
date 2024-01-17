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
public enum Gender: Int, Codable, Equatable, Hashable {

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

    public init(from decoder: Decoder) throws {
        self = try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
