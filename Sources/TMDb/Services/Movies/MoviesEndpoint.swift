import Foundation

enum MoviesEndpoint {

    static let basePath = URL(string: "/movie")!

    case details(movieID: MovieDTO.ID)
    case credits(movieID: MovieDTO.ID)
    case reviews(movieID: MovieDTO.ID, page: Int? = nil)
    case images(movieID: MovieDTO.ID)
    case videos(movieID: MovieDTO.ID)
    case recommendations(movieID: MovieDTO.ID, page: Int? = nil)
    case similar(movieID: MovieDTO.ID, page: Int? = nil)
    case popular(page: Int? = nil)

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
