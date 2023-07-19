import Foundation

///
/// A model representing a person image collection.
///
public struct PersonImageCollection: Identifiable, Decodable, Equatable, Hashable {

    ///
    /// Person identifier.
    ///
    public let id: Int

    ///
    /// Profile images.
    ///
    public let profiles: [ImageMetadata]

    ///
    /// Creates a person image collection object.
    ///
    /// - Parameters:
    ///    - id: Person identifier.
    ///    - profiles: Profile images.
    ///
    public init(id: Int, profiles: [ImageMetadata]) {
        self.id = id
        self.profiles = profiles
    }

}
