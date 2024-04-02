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
#endif

final class TMDbFactory {

    private init() {}

}

extension TMDbFactory {

    static var apiClient: some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: tmdbAPIBaseURL,
            httpClient: httpClient,
            serialiser: serialiser,
            localeProvider: localeProvider()
        )
    }

    static var authAPIClient: some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: .tmdbAPIBaseURL,
            httpClient: httpClient,
            serialiser: authSerialiser,
            localeProvider: localeProvider()
        )
    }

    static var authenticateURLBuilder: some AuthenticateURLBuilding {
        AuthenticateURLBuilder(baseURL: tmdbWebSiteURL)
    }

    static func localeProvider() -> some LocaleProviding {
        LocaleProvider(locale: .current)
    }

}

extension TMDbFactory {

    static var defaultHTTPClientAdapter: some HTTPClient {
        URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    private static let urlSession = URLSession(configuration: urlSessionConfiguration)

    private static var urlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        #if os(iOS)
            configuration.multipathServiceType = .handover
        #endif

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 30

        #if !canImport(FoundationNetworking)
            configuration.waitsForConnectivity = true
            configuration.urlCache = urlCache
        #endif

        return configuration
    }

    #if !canImport(FoundationNetworking)
        private static var urlCache: URLCache {
            URLCache(memoryCapacity: 50_000_000, diskCapacity: 1_000_000_000)
        }
    #endif

    private static var serialiser: some Serialiser {
        TMDbJSONSerialiser()
    }

    private static var authSerialiser: some Serialiser {
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

    private static var apiKey: String {
        TMDbConfiguration.shared.apiKey()
    }

    private static var httpClient: any HTTPClient {
        TMDbConfiguration.shared.httpClient()
    }

}
