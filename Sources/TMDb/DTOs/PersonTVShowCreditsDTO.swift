import Foundation

public struct PersonTVShowCreditsDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [TVShowDTO]
    public let crew: [TVShowDTO]

    public init(id: Int, cast: [TVShowDTO], crew: [TVShowDTO]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
