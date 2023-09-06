import Foundation

enum TVEpisodesEndpoint {

    case details(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int)
    case images(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int)
    case videos(tvSeriesID: TVSeries.ID, seasonNumber: Int, episodeNumber: Int)

}

extension TVEpisodesEndpoint: Endpoint {

    private static func basePath(for tvSeriesID: TVSeries.ID) -> URL {
        TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case .details(let tvSeriesID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)

        case .images(let tvSeriesID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("images")

        case .videos(let tvSeriesID, let seasonNumber, let episodeNumber):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("episode")
                .appendingPathComponent(episodeNumber)
                .appendingPathComponent("videos")
        }
    }

}
