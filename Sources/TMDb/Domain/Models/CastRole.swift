//
//  CastRole.swift
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
/// A model representing an aggregate cast member's role.
///
public struct CastRole: Codable, Equatable, Hashable, Sendable {

    ///
    /// Credit identifier.
    ///
    public let creditID: String

    ///
    /// Cast member's character.
    ///
    public let character: String

    ///
    /// Number of episodes this cast member appeared in in this role.
    ///
    public let episodeCount: Int

    ///
    /// Creates an aggregate cast member's role object.
    ///
    /// - Parameters:
    ///   - creditID: Credit identifier.
    ///   - character: Cast member's character.
    ///   - episodeCount: Number of episodes this cast member appeared in in
    ///   this role.
    ///
    public init(
        creditID: String,
        character: String,
        episodeCount: Int
    ) {
        self.creditID = creditID
        self.character = character
        self.episodeCount = episodeCount
    }

}

extension CastRole {

    private enum CodingKeys: String, CodingKey {
        case creditID = "creditId"
        case character
        case episodeCount
    }

}
