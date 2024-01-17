//
//  Certification.swift
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
/// A model representing an officially supported certification.
///
public struct Certification: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Certification's identifier (same as ``code``).
    ///
    public var id: String { code }

    ///
    /// Certification code.
    ///
    public let code: String

    ///
    /// Certification meaning.
    ///
    public let meaning: String

    ///
    /// Order number of certification in list.
    ///
    public let order: Int

    ///
    /// Creates a certification object.
    ///
    /// - Parameters:
    ///    - code: Certification code.
    ///    - meaning: Certification meaning.
    ///    - order: Order number of certification in list.
    ///
    public init(
        code: String,
        meaning: String,
        order: Int
    ) {
        self.code = code
        self.meaning = meaning
        self.order = order
    }

}

extension Certification {

    private enum CodingKeys: String, CodingKey {
        case code = "certification"
        case meaning
        case order
    }

}
