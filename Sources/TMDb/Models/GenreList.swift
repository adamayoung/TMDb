import Foundation

struct GenreList: Codable, Equatable, Hashable {

    let genres: [Genre]

    init(genres: [Genre]) {
        self.genres = genres
    }

}
