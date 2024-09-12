//
//  ImageCollection.swift
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
/// A model representing an image collection.
///
/// A collection of poster and backdrop images for a movie or TV series.
///
public struct ImageCollection: Codable, Equatable, Hashable, Sendable {

    ///
    /// Movie or TV series identifier for these images.
    ///
    public let id: Int

    ///
    /// Poster images.
    ///
    public let posters: [ImageMetadata]

    ///
    /// Logo images.
    ///
    public let logos: [ImageMetadata]

    ///
    /// Backdrop images.
    ///
    public let backdrops: [ImageMetadata]

    ///
    /// Creates an image collection object.
    ///
    /// - Parameters:
    ///    - id: Movie or TV series identifier for these images.
    ///    - posters: Poster images.
    ///    - logos: Logo images.
    ///    - backdrops: Backdrop images.
    ///
    public init(
        id: Int,
        posters: [ImageMetadata],
        logos: [ImageMetadata],
        backdrops: [ImageMetadata]
    ) {
        self.id = id
        self.posters = posters
        self.logos = logos
        self.backdrops = backdrops
    }

}
