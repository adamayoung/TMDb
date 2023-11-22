import Foundation

enum MoviesEndpoint {

    case details(movieID: Movie.ID)
    case credits(movieID: Movie.ID)
    case reviews(movieID: Movie.ID, page: Int? = nil)
    case images(movieID: Movie.ID, languageCode: String?)
    case videos(movieID: Movie.ID, languageCode: String?)
    case recommendations(movieID: Movie.ID, page: Int? = nil)
    case similar(movieID: Movie.ID, page: Int? = nil)
    case nowPlaying(page: Int? = nil)
    case popular(page: Int? = nil)
    case topRated(page: Int? = nil)
    case upcoming(page: Int? = nil)
    case watchProviders(movieID: Movie.ID)

}

extension MoviesEndpoint: Endpoint {

    private static let basePath = URL(string: "/movie")!

    var path: URL {
        switch self {
        case .details(let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)

        case .credits(let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("credits")

        case .reviews(let movieID, let page):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("reviews")
                .appendingPage(page)

        case .images(let movieID, let languageCode):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case .videos(let movieID, let languageCode):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)

        case .recommendations(let movieID, let page):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)

        case .similar(let movieID, let page):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("similar")
                .appendingPage(page)

        case .nowPlaying(let page):
            return Self.basePath
                .appendingPathComponent("now_playing")
                .appendingPage(page)

        case .popular(let page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)

        case .topRated(let page):
            return Self.basePath
                .appendingPathComponent("top_rated")
                .appendingPage(page)

        case .upcoming(let page):
            return Self.basePath
                .appendingPathComponent("upcoming")
                .appendingPage(page)
        case .watchProviders(movieID: let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("watch")
                .appendingPathComponent("providers")
        }
    }

}
