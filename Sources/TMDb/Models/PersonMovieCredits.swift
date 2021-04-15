import Foundation

public struct PersonMovieCredits: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [Movie]
    public let crew: [Movie]

    public init(id: Int, cast: [Movie], crew: [Movie]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
