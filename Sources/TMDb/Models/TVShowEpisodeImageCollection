import Foundation

/// TV Show Episode image collection.
public struct TVShowEpisodeImageCollection: Identifiable, Decodable, Equatable, Hashable {

    /// Person identifier.
    public let id: Int
    /// Episode images.
    public let stills: [ImageMetadata]

    /// Creates a new `TVShowEpisodeImageCollection`.
    ///
    /// - Parameters:
    ///    - id: TVShow identifier.
    ///    - stills: Still images.
    public init(id: Int, stills: [ImageMetadata]) {
        self.id = id
        self.stills = stills
    }

}
