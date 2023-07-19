import Foundation

///
/// A model representing a review.
///
public struct Review: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Review identifier.
    ///
    public let id: String

    ///
    /// Author of the review.
    ///
    public let author: String

    ///
    /// Review content.
    ///
    public let content: String

    ///
    /// Creates a review object.
    ///
    /// - Parameters:
    ///    - id: Review identifier.
    ///    - author: Author of the review.
    ///    - content: Review content.
    ///
    public init(
        id: String,
        author: String,
        content: String
    ) {
        self.id = id
        self.author = author
        self.content = content
    }

}
