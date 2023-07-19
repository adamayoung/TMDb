import Foundation

///
/// A model representing a genre.
///
public struct Genre: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Genre Identifier.
    ///
    public let id: Int

    ///
    /// Genre name.
    ///
    public let name: String

    ///
    /// Creates a genre object.
    ///
    /// - Parameters:
    ///    - id: Genre Identifier.
    ///    - name: Genre name.
    ///    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
