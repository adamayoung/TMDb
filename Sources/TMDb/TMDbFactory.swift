import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
            localeProvider: localeProvider()
        )
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
        Serialiser(decoder: .theMovieDatabase)
    }

}
