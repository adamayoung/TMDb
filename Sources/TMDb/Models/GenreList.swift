import Foundation

struct GenreList: Decodable, Equatable, Hashable {

    let genres: [Genre]

    init(genres: [Genre]) {
        self.genres = genres
    }

}
