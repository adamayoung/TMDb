import Foundation

final class TMDbFactory {

    private init() { }

}

extension TMDbFactory {

    static var apiClient: some APIClient {
        TMDbAPIClient(
            apiKey: TMDb.configuration.apiKey(),
            baseURL: .tmdbAPIBaseURL,
            httpClient: TMDb.configuration.httpClient(),
            serialiser: serialiser,
            localeProvider: localeProvider
        )
    }

    static func localeProvider() -> Locale {
        .current
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
