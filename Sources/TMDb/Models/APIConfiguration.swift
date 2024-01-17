//
//  APIConfiguration.swift
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
/// A model representing the API configuration.
///
/// Some elements of the API require some knowledge of this configuration data. The purpose of this is to try and keep
/// the actual API responses as light as possible. It is recommended you cache this data within your application and
/// check for updates every few days.
///
public struct APIConfiguration: Codable, Equatable, Hashable {

    ///
    /// Images configuration.
    ///
    public let images: ImagesConfiguration
    ///
    /// Change keys.
    ///
    public let changeKeys: [String]

    ///
    /// Creates an API configuration object.
    ///
    /// - Parameters:
    ///    - images: Images configuration.
    ///    - changeKeys: Change keys.
    ///
    public init(images: ImagesConfiguration, changeKeys: [String]) {
        self.images = images
        self.changeKeys = changeKeys
    }

}
