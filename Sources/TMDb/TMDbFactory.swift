//
//  TMDbFactory.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
            baseURL: .tmdbAPIBase,
            serialiser: authSerialiser(),
            httpClient: httpClient
        )
    }

    static func authenticateURLBuilder() -> some AuthenticateURLBuilding {
        AuthenticateURLBuilder(baseURL: tmdbWebSiteURL)
    }

}

extension TMDbFactory {

    static func httpClient(
        wrapping client: some HTTPClient,
        retryConfiguration: RetryConfiguration?,
        cacheConfiguration: CacheConfiguration?
    ) -> any HTTPClient {
        // Order matters: retry wraps the base client, cache wraps retry.
        // Cache hits return immediately; misses go through retry then network.
        var wrapped: any HTTPClient = client

        if let retryConfiguration {
            wrapped = RetryHTTPClient(httpClient: wrapped, configuration: retryConfiguration)
        }

        if let cacheConfiguration {
            wrapped = CacheHTTPClient(httpClient: wrapped, configuration: cacheConfiguration)
        }

        return wrapped
    }

    static func defaultHTTPClientAdapter() -> some HTTPClient {
        URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    private static let urlSession = URLSession(configuration: urlSessionConfiguration())

    private static func urlSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
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
        URL.tmdbAPIBase
    }

    private static var tmdbWebSiteURL: URL {
        URL.tmdbWebSite
    }

}
