import Foundation

/// Spoken language.
public struct SpokenLanguage: Identifiable, Decodable, Equatable, Hashable {

    /// Language code.
    public var id: String { iso6391 }
    /// Language code.
    public let iso6391: String
    /// Language name.
    public let name: String

    /// Creates a new `SpokenLanguage`.
    ///
    /// - Parameters:
    ///    - iso6391: Language code.
    ///    - name: Language name.
    public init(iso6391: String, name: String) {
        self.iso6391 = iso6391
        self.name = name
    }

}
