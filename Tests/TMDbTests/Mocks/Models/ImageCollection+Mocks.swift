import Foundation
import TMDb

extension ImageCollection {

    static var mock: Self {
        .init(
            id: .randomID,
            posters: ImageMetadata.mocks,
            logos: ImageMetadata.mocks,
            backdrops: ImageMetadata.mocks
        )
    }

}
