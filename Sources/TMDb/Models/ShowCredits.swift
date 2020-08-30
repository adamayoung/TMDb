import Foundation

public struct ShowCredits: Identifiable, Decodable {

    public let id: Int
    public let cast: [CastMember]
    public let crew: [CrewMember]

    public init(id: Int, cast: [CastMember], crew: [CrewMember]) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

}
