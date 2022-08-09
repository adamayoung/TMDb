import Foundation
@testable import TMDb

extension GenreList {

    static var mock: GenreList {
        .init(
            genres: [
                .init(id: 1, name: "Action"),
                .init(id: 2, name: "Drama"),
                .init(id: 3, name: "Sci-Fi")
            ]
        )
    }

}
