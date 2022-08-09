import Foundation
import TMDb

extension TVShowEpisode {

    static var mock: Self {
        let id = Int.randomID

        return .init(id: id, name: "Episode \(id)",
                     episodeNumber: .random(in: 0...23),
                     seasonNumber: .random(in: 0...10))
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
