import Foundation

public struct PersonCombinedCreditsDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [ShowDTO]
    public let crew: [ShowDTO]

    public init(id: Int, cast: [ShowDTO], crew: [ShowDTO]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
