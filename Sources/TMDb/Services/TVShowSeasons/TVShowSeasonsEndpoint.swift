import Foundation

enum TVShowSeasonsEndpoint {

    static let basePath = "season"

    case details(tvShowID: TVShow.ID, seasonNumber: Int)
    case images(tvShowID: TVShow.ID, seasonNumber: Int)
    case videos(tvShowID: TVShow.ID, seasonNumber: Int)

}

extension TVShowSeasonsEndpoint: Endpoint {

    var url: URL {
        switch self {
        case .details(let tvShowID, let seasonNumber):
            return TVShowsEndpoint.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent(Self.basePath)
                .appendingPathComponent(seasonNumber)

        case .images(let tvShowID, let seasonNumber):
            return TVShowsEndpoint.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent(Self.basePath)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("images")

        case .videos(let tvShowID, let seasonNumber):
            return TVShowsEndpoint.basePath
                .appendingPathComponent(tvShowID)
                .appendingPathComponent(Self.basePath)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("videos")
        }
    }

}
