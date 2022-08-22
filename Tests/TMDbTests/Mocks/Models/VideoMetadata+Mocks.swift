import Foundation
import TMDb

extension VideoMetadata {

    static func mock(
        id: String = .randomID,
        name: String = .randomString,
        site: String = "YouTube",
        key: String = "abc123",
        type: VideoType = .trailer,
        size: VideoSize = .s1080
    ) -> Self {
        .init(
            id: id,
            name: name,
            site: site,
            key: key,
            type: type,
            size: size
        )
    }

}

extension Array where Element == VideoMetadata {

    static var mocks: [Element] {
        [.mock(), .mock(), .mock()]
    }

}
