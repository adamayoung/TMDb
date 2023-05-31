import Foundation

final class TMDbFactory {

    private init() { }

}

extension TMDbFactory {

    static func apiClient(apiKey: String) -> some APIClient {
        TMDbAPIClient(
            apiKey: apiKey,
            baseURL: .tmdbAPIBaseURL,
            urlSession: .shared,
            serialiser: serialiser
        )
    }

}

extension TMDbFactory {

    private static var serialiser: some Serialiser {
        Serialiser(decoder: .theMovieDatabase)
    }

}
