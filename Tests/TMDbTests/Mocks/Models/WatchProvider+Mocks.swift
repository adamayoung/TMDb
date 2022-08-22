import Foundation
import TMDb

extension WatchProvider {

    static func mock(
        id: Int = .randomID,
        name: String = .randomString,
        logoPath: URL = URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
    ) -> Self {
        .init(
            id: id,
            name: name,
            logoPath: logoPath
        )
    }

    static var netflix: Self {
        .mock(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
        )
    }

}
