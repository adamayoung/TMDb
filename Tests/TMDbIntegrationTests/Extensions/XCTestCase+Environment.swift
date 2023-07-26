import XCTest

extension XCTestCase {

    var tmdbAPIKey: String {
        Self.tmdbAPIKey
    }

    static var tmdbAPIKey: String {
        guard let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] else {
            preconditionFailure("TMDb configuration API key not set. Use TMDB_API_KEY environment variable.")
        }

        return apiKey
    }

}
