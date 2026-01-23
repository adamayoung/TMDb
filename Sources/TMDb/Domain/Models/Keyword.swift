//
//  Keyword.swift
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
/// A model representing a keyword.
///
public struct Keyword: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Keyword identifier.
    ///
    public let id: Int

    ///
    /// Keyword name.
    ///
    public let name: String

    ///
    /// Creates a keyword object.
    ///
    /// - Parameters:
    ///   - id: Keyword identifier.
    ///   - name: Keyword name.
    ///
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
