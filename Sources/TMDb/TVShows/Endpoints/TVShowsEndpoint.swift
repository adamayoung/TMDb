import Foundation

enum TVShowsEndpoint {

    case details(tvShowID: TVShow.ID)
    case credits(tvShowID: TVShow.ID)
    case reviews(tvShowID: TVShow.ID, page: Int? = nil)
    case images(tvShowID: TVShow.ID, languageCode: String?)
    case videos(tvShowID: TVShow.ID, languageCode: String?)
    case recommendations(tvShowID: TVShow.ID, page: Int? = nil)
    case similar(tvShowID: TVShow.ID, page: Int? = nil)
    case popular(page: Int? = nil)

}

extension TVShowsEndpoint: Endpoint {

    private static let basePath = URL(string: "/tv")!

    var path: URL {
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

        case .images(let tvShowID, let languageCode):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case .videos(let tvShowID, let languageCode):
            return Self.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)

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
