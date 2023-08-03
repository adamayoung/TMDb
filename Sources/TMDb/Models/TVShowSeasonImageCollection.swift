import Foundation

///
/// A model representing a TV show season image collection.
///
public struct TVShowSeasonImageCollection: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Season images.
    ///
    public let posters: [ImageMetadata]

    ///
    /// Creates a TV show season image collection.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - posters: Still images.
    ///
    public init(id: Int, posters: [ImageMetadata]) {
        self.id = id
        self.posters = posters
    }

}
