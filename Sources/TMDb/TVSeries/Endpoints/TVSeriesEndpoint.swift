import Foundation

enum TVSeriesEndpoint {

    case details(tvSeriesID: TVSeries.ID)
    case credits(tvSeriesID: TVSeries.ID)
    case reviews(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case images(tvSeriesID: TVSeries.ID, languageCode: String?)
    case videos(tvSeriesID: TVSeries.ID, languageCode: String?)
    case recommendations(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case similar(tvSeriesID: TVSeries.ID, page: Int? = nil)
    case popular(page: Int? = nil)
    case watchProviders(tvSeriesID: TVSeries.ID)

}

extension TVSeriesEndpoint: Endpoint {

    private static let basePath = URL(string: "/tv")!

    var path: URL {
        switch self {
        case .details(let tvSeriesID):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)

        case .credits(let tvSeriesID):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("credits")

        case .reviews(let tvSeriesID, let page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("reviews")
                .appendingPage(page)

        case .images(let tvSeriesID, let languageCode):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case .videos(let tvSeriesID, let languageCode):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)

        case .recommendations(let tvSeriesID, let page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("recommendations")
                .appendingPage(page)

        case .similar(let tvSeriesID, let page):
            return Self.basePath
                .appendingPathComponent(tvSeriesID)
                .appendingPathComponent("similar")
                .appendingPage(page)

        case .popular(let page):
            return Self.basePath
                .appendingPathComponent("popular")
                .appendingPage(page)
            case .watchProviders(tvSeriesID: let tvSeriesID):
                return Self.basePath
                    .appendingPathComponent(tvSeriesID)
                    .appendingPathComponent("watch")
                    .appendingPathComponent("providers")
        }
    }

}
