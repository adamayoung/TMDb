import Foundation
import TMDb

extension PersonImageCollection {

    static var mock: Self {
        .init(
            id: .randomID,
            profiles: ImageMetadata.mocks
        )
    }

}
