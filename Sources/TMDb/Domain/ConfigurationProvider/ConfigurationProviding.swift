//
//  ConfigurationProviding.swift
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
/// An interface to provide configuration for service.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public protocol ConfigurationProviding {

    ///
    /// TMDb API key.
    ///
    var apiKey: String { get }

    ///
    /// The HTTP client adapter for making HTTP requests.
    ///
    var httpClient: any HTTPClient { get }

}
