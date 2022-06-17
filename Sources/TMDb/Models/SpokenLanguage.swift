import Foundation

/// Spoken language.
public struct SpokenLanguage: Identifiable, Decodable, Equatable, Hashable {

    /// Language code.
    public var id: String { languageCode }
    /// ISO 639-1 language code.
    public let languageCode: String
    /// Language name.
    public let name: String

    /// Creates a new `SpokenLanguage`.
    ///
    /// - Parameters:
    ///    - languageCode: ISO 639-1 language code.
    ///    - name: Language name.
    public init(languageCode: String, name: String) {
        self.languageCode = languageCode
        self.name = name
    }

}

extension SpokenLanguage {

    private enum CodingKeys: String, CodingKey {
        case languageCode = "iso6391"
        case name
    }

}
