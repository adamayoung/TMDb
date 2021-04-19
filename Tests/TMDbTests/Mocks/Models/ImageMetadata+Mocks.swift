import Foundation
import TMDb

extension ImageMetadata {

    static var mock: Self {
        .init(
            filePath: URL(string: "/\(String.randomString).jpg")!,
            width: Int.random(in: 10...100),
            height: Int.random(in: 10...100)
        )
    }

    static var mocks: [Self] {
        (0...Int.random(in: 1...10)).map { _ in
            .mock
        }
    }

}
