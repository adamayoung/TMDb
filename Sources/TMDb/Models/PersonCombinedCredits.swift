import Foundation

public struct PersonCombinedCredits: Identifiable, Decodable {

    public let id: Int
    public let cast: [ShowListResultItem]
    public let crew: [ShowListResultItem]

    public init(id: Int, cast: [ShowListResultItem], crew: [ShowListResultItem]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
