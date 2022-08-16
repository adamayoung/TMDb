import Foundation
import TMDb

extension WatchProvider {

    static var mock: Self {
        .init(
            id: 8,
            name: "Netflix",
            logoPath: URL(string: "/t2yyOv40HZeVlLjYsCsPHnWLk4W.jpg")!
        )
    }

}
