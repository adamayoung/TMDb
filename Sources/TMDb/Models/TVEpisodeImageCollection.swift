//
//  TVEpisodeImageCollection.swift
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
/// A model representing a TV episode image collection.
///
public struct TVEpisodeImageCollection: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Episode images.
    ///
    public let stills: [ImageMetadata]

    ///
    /// Creates a TV episode image collection.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - stills: Still images.
    ///
    public init(id: Int, stills: [ImageMetadata]) {
        self.id = id
        self.stills = stills
    }

}
