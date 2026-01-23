//
//  NetworkAlternativeName.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A model representing an alternative name for a TV network.
///
public struct NetworkAlternativeName: Codable, Equatable, Hashable, Sendable {

    ///
    /// The alternative name.
    ///
    public let name: String

    ///
    /// The type of alternative name.
    ///
    public let type: String

    ///
    /// Creates an alternative name for a TV network.
    ///
    /// - Parameters:
    ///    - name: The alternative name.
    ///    - type: The type of alternative name.
    ///
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }

}
