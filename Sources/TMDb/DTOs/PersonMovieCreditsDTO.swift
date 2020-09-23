import Foundation

public struct PersonMovieCreditsDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [MovieDTO]
    public let crew: [MovieDTO]

    public init(id: Int, cast: [MovieDTO], crew: [MovieDTO]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
