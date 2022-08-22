import Foundation
import TMDb

extension PersonImageCollection {

    static func mock(
        id: Int = .randomID,
        profiles: [ImageMetadata] = [.mock(), .mock()]
    ) -> Self {
        .init(
            id: id,
            profiles: profiles
        )
    }

}
