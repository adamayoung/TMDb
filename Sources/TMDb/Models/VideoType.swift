import Foundation

/// Video type.
public enum VideoType: String, Decodable, Equatable, Hashable {

    /// Trailer.
    case trailer = "Trailer"
    /// Teaser.
    case teaser = "Teaser"
    /// Clip.
    case clip = "Clip"
    /// Opening credits.
    case openingCredits = "Opening Credits"
    /// Featurette
    case featurette = "Featurette"
    /// Behind the Scenes
    case behindTheScenes = "Behind the Scenes"
    /// Bloopers.
    case bloopers = "Bloopers"

}
