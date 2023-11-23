import Foundation

enum TVSeasonsEndpoint {

    case details(tvSeriesID: TVSeries.ID, seasonNumber: Int)
    case images(tvSeriesID: TVSeries.ID, seasonNumber: Int, languageCode: String?)
    case videos(tvSeriesID: TVSeries.ID, seasonNumber: Int, languageCode: String?)

}

extension TVSeasonsEndpoint: Endpoint {

    private static func basePath(for tvSeriesID: TVSeries.ID) -> URL {
        TVSeriesEndpoint.details(tvSeriesID: tvSeriesID).path
            .appendingPathComponent("season")
    }

    var path: URL {
        switch self {
        case .details(let tvSeriesID, let seasonNumber):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)

        case .images(let tvSeriesID, let seasonNumber, let languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("images")
                .appendingImageLanguage(languageCode)

        case .videos(let tvSeriesID, let seasonNumber, let languageCode):
            return Self.basePath(for: tvSeriesID)
                .appendingPathComponent(seasonNumber)
                .appendingPathComponent("videos")
                .appendingVideoLanguage(languageCode)
        }
    }

}
