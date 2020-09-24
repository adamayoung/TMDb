import Foundation

public struct ShowCreditsDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let cast: [CastMemberDTO]
    public let crew: [CrewMemberDTO]

    public init(id: Int, cast: [CastMemberDTO], crew: [CrewMemberDTO]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
