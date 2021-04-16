import Foundation
import TMDb

extension VideoMetadata {

    static var mock: Self {
        .init(
            id: .randomID,
            name: .randomString,
            site: .randomString,
            key: .randomString,
            type: .trailer,
            size: .s1080
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
