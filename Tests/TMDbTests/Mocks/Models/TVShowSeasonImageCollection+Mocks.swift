import Foundation
import TMDb

extension TVShowSeasonImageCollection {

    static func mock(
        id: Int = .randomID,
        posters: [ImageMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            posters: posters
        )
    }

}
