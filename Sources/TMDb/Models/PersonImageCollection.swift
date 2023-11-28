//
//  PersonImageCollection.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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
/// A model representing a person image collection.
///
public struct PersonImageCollection: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Profile images.
    ///
    public let profiles: [ImageMetadata]

    ///
    /// Creates a person image collection object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - profiles: Profile images.
    ///
    public init(id: Int, profiles: [ImageMetadata]) {
        self.id = id
        self.profiles = profiles
    }

}
