import Foundation

public struct GenreDTO: Identifiable, Decodable, Equatable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
