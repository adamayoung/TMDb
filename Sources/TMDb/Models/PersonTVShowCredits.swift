import Foundation

public struct PersonTVShowCredits: Identifiable, Decodable {

    public let id: Int
    public let cast: [TVShow]
    public let crew: [TVShow]

    public init(id: Int, cast: [TVShow], crew: [TVShow]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
