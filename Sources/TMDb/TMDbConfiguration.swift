//
//  TMDbConfiguration.swift
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
/// A model representing configuration settings for TMDb.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public final class TMDbConfiguration: ConfigurationProviding, Sendable {

    ///
    /// TMDb API key.
    ///
    public let apiKey: String

    ///
    /// The HTTP client adapter for making HTTP requests.
    ///
    public let httpClient: any HTTPClient

    ///
    /// Creates a TMDb configuration object using URLSession as the HTTP client.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///
    public convenience init(apiKey: String) {
        self.init(
            apiKey: apiKey,
            httpClient: TMDbFactory.defaultHTTPClientAdapter()
        )
    }

    ///
    /// Creates a TMDb configuration object.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///    - httpClient: A custom HTTP client adapter for making HTTP requests.
    ///
    public init(
        apiKey: String,
        httpClient: some HTTPClient
    ) {
        self.apiKey = apiKey
        self.httpClient = httpClient
    }

}
