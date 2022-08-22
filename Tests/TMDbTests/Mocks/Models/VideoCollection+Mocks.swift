import Foundation
import TMDb

extension VideoCollection {

    static func mock(
        id: Int = .randomID,
        results: [VideoMetadata] = .mocks
    ) -> Self {
        .init(
            id: id,
            results: results
        )
    }

}
