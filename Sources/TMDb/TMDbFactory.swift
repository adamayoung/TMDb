import Foundation

final class TMDbFactory {

    private init() { }

}

extension TMDbFactory {

    static func apiClient(apiKey: String) -> some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: .tmdbAPIBaseURL,
            urlSession: urlSession,
            serialiser: serialiser
        )
    }

}

extension TMDbFactory {

    private static let urlSession = URLSession(configuration: urlSessionConfiguration)

    private static var urlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        #if !os(macOS)
            configuration.multipathServiceType = .handover
        #endif

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
