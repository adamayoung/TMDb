import Foundation

public struct PersonCombinedCredits: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [Show]
    public let crew: [Show]

    public init(id: Int, cast: [Show], crew: [Show]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
