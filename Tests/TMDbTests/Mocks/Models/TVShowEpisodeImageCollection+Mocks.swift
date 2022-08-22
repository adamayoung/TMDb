import Foundation
import TMDb

extension TVShowEpisodeImageCollection {

    static func mock(
        id: Int = .randomID,
        stills: [ImageMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            stills: stills
        )
    }

}
