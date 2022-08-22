import Foundation
import TMDb

extension TVShowSeason {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        seasonNumber: Int = Int.random(in: 1...10),
        overview: String? = .randomString,
        airDate: Date? = .random,
        posterPath: URL? = nil,
        episodes: [TVShowEpisode]? = .mocks
    ) -> Self {
        .init(
            id: id,
            name: name ?? "TV Show Season \(id)",
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            posterPath: posterPath,
            episodes: episodes
        )
    }

}
