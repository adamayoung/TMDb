//
//  TMDbFactory.swift
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

#if canImport(FoundationNetworking)
    import FoundationNetworking

    extension URLSession: @unchecked Sendable {}

    extension URL: @unchecked Sendable {}
#endif

final class TMDbFactory {

    private init() {}

}

extension TMDbFactory {

    static func apiClient(apiKey: String, httpClient: some HTTPClient) -> some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: tmdbAPIBaseURL,
            serialiser: serialiser(),
            httpClient: httpClient
        )
    }

    static func authAPIClient(apiKey: String, httpClient: some HTTPClient) -> some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: .tmdbAPIBaseURL,
            serialiser: authSerialiser(),
            httpClient: httpClient
        )
    }

    static func authenticateURLBuilder() -> some AuthenticateURLBuilding {
        AuthenticateURLBuilder(baseURL: tmdbWebSiteURL)
    }

}

extension TMDbFactory {

    static func defaultHTTPClientAdapter() -> some HTTPClient {
        URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    private static let urlSession = URLSession(configuration: urlSessionConfiguration())

    private static func urlSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        #if os(iOS)
            configuration.multipathServiceType = .none
        #endif

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 30

        #if !canImport(FoundationNetworking)
            configuration.waitsForConnectivity = true
            configuration.urlCache = urlCache()
        #endif

        return configuration
    }

    #if !canImport(FoundationNetworking)
        private static func urlCache() -> URLCache {
            URLCache(memoryCapacity: 50_000_000, diskCapacity: 1_000_000_000)
        }
    #endif

    private static func serialiser() -> some Serialiser {
        TMDbJSONSerialiser()
    }

    private static func authSerialiser() -> some Serialiser {
        TMDbAuthJSONSerialiser()
    }

}

extension TMDbFactory {

    private static var tmdbAPIBaseURL: URL {
        URL.tmdbAPIBaseURL
    }

    private static var tmdbWebSiteURL: URL {
        URL.tmdbWebSiteURL
    }

}
