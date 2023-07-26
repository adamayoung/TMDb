import Foundation

final class TMDbFactory {

    private init() { }

}

extension TMDbFactory {

    static func apiClient(config: TMDbConfiguration) -> some APIClient {
        TMDbAPIClient(
            apiKey: config.apiKey,
            baseURL: .tmdbAPIBaseURL,
            httpClient: httpClient(config: config),
            serialiser: serialiser
        )
    }

}

extension TMDbFactory {

    private static func httpClient(config: TMDbConfiguration) -> HTTPClient {
        config.httpClient ?? defaultHTTPClientAdapter
    }

}

extension TMDbFactory {

    private static var defaultHTTPClientAdapter: HTTPClient {
        URLSessionHTTPClientAdapter(urlSession: urlSession)
    }

    private static let urlSession = URLSession(configuration: urlSessionConfiguration)

    private static var urlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        #if !os(macOS)
            configuration.multipathServiceType = .handover
        #endif

        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCache = urlCache

        return configuration
    }

    private static var urlCache: URLCache {
        URLCache(memoryCapacity: 50_000_000, diskCapacity: 1_000_000_000)
    }

    private static var serialiser: some Serialiser {
        Serialiser(decoder: .theMovieDatabase)
    }

}
