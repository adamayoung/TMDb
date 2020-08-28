import Foundation

public struct PersonMovieCredits: Identifiable, Decodable {

    public let id: Int
    public let cast: [MovieListResultItem]
    public let crew: [MovieListResultItem]

    public init(id: Int, cast: [MovieListResultItem], crew: [MovieListResultItem]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
