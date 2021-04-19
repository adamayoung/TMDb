import Foundation
import TMDb

extension VideoCollection {

    static var mock: Self {
        .init(
            id: .randomID,
            results: VideoMetadata.mocks
        )
    }

}
