import Foundation

enum TVShowsEndpoint {

    static let basePath = URL(string: "/tv")!

    case details(tvShowID: TVShow.ID)
    case credits(tvShowID: TVShow.ID)
    case reviews(tvShowID: TVShow.ID, page: Int? = nil)
    case images(tvShowID: TVShow.ID)
    case videos(tvShowID: TVShow.ID)
    case recommendations(tvShowID: TVShow.ID, page: Int? = nil)
    case similar(tvShowID: TVShow.ID, page: Int? = nil)
    case popular(page: Int? = nil)

}

extension TVShowsEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .details(let tvShowID):
            return Self.basePath
                .appendingPathComponent(tvShowID)

        case .credits(let tvShowID):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("credits")

        case .reviews(let tvShowID, let page):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("reviews")
                .appendingPage(page)

        case .images(let tvShowID):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("images")

        case .videos(let tvShowID):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("videos")

        case .recommendations(let tvShowID, let page):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)

        case .similar(let tvShowID, let page):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("similar")
                .appendingPage(page)

        case .popular(let page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)
        }
    }

}
