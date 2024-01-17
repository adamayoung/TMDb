//
//  Review.swift
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
/// A model representing a review.
///
public struct Review: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Review identifier.
    ///
    public let id: String

    ///
    /// Author of the review.
    ///
    public let author: String

    ///
    /// Review content.
    ///
    public let content: String

    ///
    /// Creates a review object.
    ///
    /// - Parameters:
    ///    - id: Review identifier.
    ///    - author: Author of the review.
    ///    - content: Review content.
    ///
    public init(
        id: String,
        author: String,
        content: String
    ) {
        self.id = id
        self.author = author
        self.content = content
    }

}
