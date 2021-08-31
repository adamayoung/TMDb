import Foundation

/// A review.
public struct Review: Identifiable, Decodable, Equatable, Hashable {

    /// Review identifier.
    public let id: String
    /// Author of the review.
    public let author: String
    /// Review content.
    public let content: String

    /// Creates a new `Review`.
    ///
    /// - Parameters:
    ///    - id: Review identifier.
    ///    - author: Author of the review.
    ///    - content: Review content.
    public init(id: String, author: String, content: String) {
        self.id = id
        self.author = author
        self.content = content
    }

}
