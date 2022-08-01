import Foundation
import TMDb

extension TVShowEpisodeImageCollection {

    static var mock: Self {
        .init(
            id: .randomID,
            stills: ImageMetadata.mocks
        )
    }

}