import Foundation

enum TVShowEpisodesEndpoint {

    case details(tvShowID: TVShow.ID, seasonNumber: Int, episodeNumber: Int)
    case images(tvShowID: TVShow.ID, seasonNumber: Int, episodeNumber: Int)
    case videos(tvShowID: TVShow.ID, seasonNumber: Int, episodeNumber: Int)

}

extension TVShowEpisodesEndpoint: Endpoint {

    private static func basePath(for tvShowID: TVShow.ID) -> URL {
        TVShowsEndpoint.details(tvShowID: tvShowID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case .details(let tvShowID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)

        case .images(let tvShowID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("images")

        case .videos(let tvShowID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvShowID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("videos")
        }
    }

}
