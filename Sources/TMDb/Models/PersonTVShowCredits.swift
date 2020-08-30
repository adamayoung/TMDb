import Foundation

public struct PersonTVShowCredits: Identifiable, Decodable {

    public let id: Int
    public let cast: [TVShowListResultItem]
    public let crew: [TVShowListResultItem]

    public init(id: Int, cast: [TVShowListResultItem], crew: [TVShowListResultItem]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
