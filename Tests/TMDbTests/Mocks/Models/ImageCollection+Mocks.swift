import Foundation
import TMDb

extension ImageCollection {

    static func mock(
        id: Int = .randomID,
        posters: [ImageMetadata] = .mocks,
        logos: [ImageMetadata] = .mocks,
        backdrops: [ImageMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            posters: posters,
            logos: logos,
            backdrops: backdrops
        )
    }

}
