import Foundation

enum TVShowSeasonsEndpoint {

    case details(tvShowID: TVShow.ID, seasonNumber: Int)
    case images(tvShowID: TVShow.ID, seasonNumber: Int)
    case videos(tvShowID: TVShow.ID, seasonNumber: Int)

}

extension TVShowSeasonsEndpoint: Endpoint {

    private static func basePath(for tvShowID: TVShow.ID) -> URL {
        TVShowsEndpoint.details(tvShowID: tvShowID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case .details(let tvShowID, let seasonNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)

        case .images(let tvShowID, let seasonNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("images")
                .appendingImageLanguage()

        case .videos(let tvShowID, let seasonNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("videos")
                .appendingVideoLanguage()
        }
    }

}
