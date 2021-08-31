import Foundation

/// Genre.
public struct Genre: Identifiable, Decodable, Equatable, Hashable {

    /// Genre Identifier.
    public let id: Int
    /// Genre name.
    public let name: String

    /// Creates a new `Genre`.
    ///
    /// - Parameters:
    ///    - id: Genre Identifier.
    ///    - name: Genre name.
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
