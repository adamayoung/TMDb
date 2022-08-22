import Foundation
import TMDb

extension TVShowEpisode {

    static func mock(
        id: Int = .randomID,
        name: String? = nil,
        episodeNumber: Int = .random(in: 0...23),
        seasonNumber: Int = .random(in: 0...10),
        overview: String? = .randomString,
        airDate: Date? = .random,
        productionCode: String? = nil,
        stillPath: URL? = nil,
        crew: [CrewMember]? = nil,
        guestStars: [CastMember]? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) -> Self {
        .init(
            id: id,
            name: name ?? "TV Show Episode \(id)",
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            overview: overview,
            airDate: airDate,
            productionCode: productionCode,
            stillPath: stillPath,
            crew: crew,
            guestStars: guestStars,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }

}

extension Array where Element == TVShowEpisode {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock(), .mock()]
    }

}
