import Foundation

enum MoviesEndpoint {

    static let basePath = URL(string: "/movie")!

    case details(movieID: Movie.ID)
    case credits(movieID: Movie.ID)
    case reviews(movieID: Movie.ID, page: Int?)
    case images(movieID: Movie.ID)
    case videos(movieID: Movie.ID)
    case recommendations(movieID: Movie.ID, page: Int?)
    case similar(movieID: Movie.ID, page: Int?)
    case popular(page: Int?)

}

extension MoviesEndpoint: Endpoint {

    var url: URL {
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

        case .images(let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("images")

        case .videos(let movieID):
            return Self.basePath
                .appendingPathComponent(movieID)
                .appendingPathComponent("videos")

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

        case .popular(let page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)
        }
    }

}
