//
//  MediaListItemStatus.swift
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
/// A model representing the presence status of an item in a list.
///
public struct MediaListItemStatus: Codable, Equatable, Hashable, Sendable {

    ///
    /// List identifier.
    ///
    public let id: String

    ///
    /// Whether the item is present in the list.
    ///
    public let isPresent: Bool

    ///
    /// Creates a media list item status object.
    ///
    /// - Parameters:
    ///    - id: List identifier.
    ///    - isPresent: Whether the item is present in the list.
    ///
    public init(id: String, isPresent: Bool) {
        self.id = id
        self.isPresent = isPresent
    }

}

extension MediaListItemStatus {

    private enum CodingKeys: String, CodingKey {
        case id
        case isPresent = "itemPresent"
    }

}
