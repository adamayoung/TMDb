import Foundation

/// A collection of videos images for a movie or TV show.
public struct VideoCollection: Identifiable, Decodable, Equatable, Hashable {

    /// Movie or TV show identifier.
    public let id: Int
    /// Videos.
    public let results: [VideoMetadata]

    /// Creates a new `VideoCollection`.
    ///
    /// - Parameters:
    ///    - id: Movie or TV show identifier.
    ///    - results: Videos.
    public init(id: Int, results: [VideoMetadata]) {
        self.id = id
        self.results = results
    }

}
