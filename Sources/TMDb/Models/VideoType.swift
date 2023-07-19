import Foundation

///
/// A model representing a video type.
///
public enum VideoType: String, Codable, Equatable, Hashable {

    ///
    /// Trailer.
    ///
    case trailer = "Trailer"

    ///
    /// Teaser.
    ///
    case teaser = "Teaser"

    ///
    /// Clip.
    ///
    case clip = "Clip"

    ///
    /// Opening credits.
    ///
    case openingCredits = "Opening Credits"

    ///
    /// Featurette.
    ///
    case featurette = "Featurette"

    ///
    /// Behind the Scenes.
    ///
    case behindTheScenes = "Behind the Scenes"

    ///
    /// Bloopers.
    ///
    case bloopers = "Bloopers"

    ///
    /// Unknown.
    ///
    case unknown

    public init(from decoder: Decoder) throws {
        self = try VideoType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }

}
