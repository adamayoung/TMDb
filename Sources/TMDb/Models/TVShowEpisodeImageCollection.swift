import Foundation

///
/// A model representing a TV show episode image collection.
///
public struct TVShowEpisodeImageCollection: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Collection identifier.
    ///
    public let id: Int

    ///
    /// Episode images.
    ///
    public let stills: [ImageMetadata]

    ///
    /// Creates a TV show episode image collection.
    ///
    /// - Parameters:
    ///    - id: Collection identifier.
    ///    - stills: Still images.
    ///
    public init(id: Int, stills: [ImageMetadata]) {
        self.id = id
        self.stills = stills
    }

}
